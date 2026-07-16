use std::collections::HashMap;

use anyhow::Result;
use prost::Message;
use redis::{AsyncCommands, aio::MultiplexedConnection};

const DATA_PREFIX: &str = "data"; // data store
const SEARCH_INDEX_PREFIX: &str = "sid"; // search indexes

// Representation in db e.g
// table_name:data:{record_key} -> {protobuf bytes}
// table_name:sid:{search_index}:{record_key} -> {record_key}

pub struct Table {
  name: String,
  db_con: MultiplexedConnection,
}

impl Table {
  //
  // - Private Functions -
  //
  fn __generate_uuid() -> String {
    // generate a unique key for the record
    uuid::Uuid::now_v7().to_string()
  }

  fn __insert_search_indexes(
    &self,
    pipe: &mut redis::Pipeline,
    id: String,
    search_indexes: Vec<String>,
    expire_seconds: Option<i64>,
  ) -> Result<()> {
    // Using SET to store the value
    for search_index in search_indexes {
      let full_key = format!("{}:{}:{}:{}", self.name, SEARCH_INDEX_PREFIX, search_index, id);
      pipe.set(full_key.clone(), id.clone());

      // Set expiration if provided
      if let Some(expire) = expire_seconds {
        pipe.expire(full_key, expire);
      }
    }

    Ok(())
  }

  async fn __remove_search_indexes(&mut self, pipe: &mut redis::Pipeline, id: String) -> Result<()> {
    // Pattern to match keys
    let pattern = format!("{}:{}:*:{}", self.name, SEARCH_INDEX_PREFIX, id);

    // AsyncIter handles cursor automatically
    let mut sid_keys_to_delete: Vec<String> = Vec::new();
    let mut iter = match self.db_con.scan_match::<String, String>(pattern).await {
      Ok(it) => it,
      Err(e) => {
        log::error!("Failed to scan keys for deletion: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    while let Some(key) = iter.next_item().await {
      let key = match key {
        Ok(k) => k,
        Err(e) => {
          log::error!("Failed to scan keys for deletion: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      };
      sid_keys_to_delete.push(key);
    }

    // Delete all matched keys
    for del_key in sid_keys_to_delete {
      pipe.del(del_key);
    }

    Ok(())
  }

  fn __insert_record<T: Message + Default>(
    &self,
    pipe: &mut redis::Pipeline,
    id: String,
    record: &T,
    expire_seconds: Option<i64>,
  ) -> Result<()> {
    // Encode data into protobuf bytes
    let data = Message::encode_to_vec(record);
    // Insert data
    let full_key = format!("{}:{}:{}", self.name, DATA_PREFIX, id);
    pipe.set(full_key.clone(), data);

    // Set expiration if provided
    if let Some(expire) = expire_seconds {
      pipe.expire(full_key, expire);
    }

    Ok(())
  }

  fn __remove_record(&self, pipe: &mut redis::Pipeline, id: String) -> Result<()> {
    let full_key = format!("{}:{}:{}", self.name, DATA_PREFIX, id);
    pipe.del(full_key);
    Ok(())
  }

  async fn __get_record<T: Message + Default>(&mut self, id: String) -> Result<Option<T>> {
    let full_key = format!("{}:{}:{}", self.name, DATA_PREFIX, id);
    let bytes: Vec<u8> = match self.db_con.get(full_key).await {
      Ok(v) => v,
      Err(e) => {
        log::error!("Failed to get record from Redis: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    // If bytes are empty, the key doesn't exist
    if bytes.is_empty() {
      return Ok(None);
    }

    let record: T = match Message::decode(bytes.as_slice()) {
      Ok(rec) => rec,
      Err(e) => {
        log::error!("Failed to decode record from Redis: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(Some(record))
  }

  async fn __get_records<T: Message + Default>(&mut self, ids: Vec<String>) -> Result<HashMap<String, T>> {
    let mut records: HashMap<String, T> = HashMap::new();

    // Redis rejects MGET with zero keys ("wrong number of arguments"), which happens
    // whenever a search index has no matches yet (e.g. no records committed yet).
    if ids.is_empty() {
      return Ok(records);
    }

    let full_keys: Vec<String> = ids.iter().map(|id| format!("{}:{}:{}", self.name, DATA_PREFIX, id)).collect();

    // Get all values at once
    let bytes_vec: Vec<Vec<u8>> = match self.db_con.mget(full_keys).await {
      Ok(v) => v,
      Err(e) => {
        log::error!("Failed to get records from Redis: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    for (id, bytes) in ids.into_iter().zip(bytes_vec.into_iter()) {
      if bytes.is_empty() {
        continue; // Skip non-existing records
      }

      let record: T = match Message::decode(bytes.as_slice()) {
        Ok(rec) => rec,
        Err(e) => {
          log::error!("Failed to decode record from Redis: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      };

      records.insert(id, record);
    }

    Ok(records)
  }

  async fn __get_record_ids_multi_sid(&mut self, search_indexes: Vec<String>) -> Result<Vec<String>> {
    let mut all_ids: Vec<String> = Vec::new();
    let mut db_con = self.db_con.clone();

    for search_index in search_indexes {
      // Pattern to match keys
      let pattern = format!("{}:{}:{}:*", self.name, SEARCH_INDEX_PREFIX, search_index);

      // Scan for all matching keys
      let mut sid_keys: Vec<String> = Vec::new();
      let mut iter = match db_con.scan_match::<String, String>(pattern).await {
        Ok(it) => it,
        Err(e) => {
          log::error!("Failed to scan keys: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      };

      while let Some(sid_key) = iter.next_item().await {
        match sid_key {
          Ok(k) => sid_keys.push(k),
          Err(e) => {
            log::error!("Failed to scan record keys: {}", e);
            return Err(anyhow::anyhow!(e));
          }
        }
      }

      if sid_keys.is_empty() {
        continue;
      }

      // Get all values (UUIDs) at once
      let ids: Vec<String> = match self.db_con.mget(sid_keys).await {
        Ok(v) => v,
        Err(e) => {
          log::error!("Failed to get records from Redis: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      };

      all_ids.extend(ids);
    }

    Ok(all_ids)
  }

  async fn __get_record_ids_single_sid(&mut self, search_index: String) -> Result<Vec<String>> {
    // Pattern to match keys
    let pattern = format!("{}:{}:{}:*", self.name, SEARCH_INDEX_PREFIX, search_index);
    let mut db_con = self.db_con.clone();

    // Scan for all matching keys
    let mut sid_keys: Vec<String> = Vec::new();
    let mut iter = match db_con.scan_match::<String, String>(pattern).await {
      Ok(it) => it,
      Err(e) => {
        log::error!("Failed to scan keys: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    while let Some(sid_key) = iter.next_item().await {
      match sid_key {
        Ok(k) => sid_keys.push(k),
        Err(e) => {
          log::error!("Failed to scan record keys: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      }
    }

    if sid_keys.is_empty() {
      return Ok(Vec::new());
    }

    // Get all values (UUIDs) at once - reuse connection from scan
    let ids: Vec<String> = match self.db_con.mget(sid_keys).await {
      Ok(v) => v,
      Err(e) => {
        log::error!("Failed to get records from Redis: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(ids)
  }

  //
  // - Public Functions -
  //

  // Get a table instance
  pub fn get_table(name: &str, db: MultiplexedConnection) -> Self {
    Table { name: name.to_string(), db_con: db }
  }

  /// Insert record into the table
  pub async fn insert<T: Message + Default>(
    &mut self,
    id: Option<String>,
    value: &T,
    search_indexes: Vec<String>,
    expire_seconds: Option<i64>,
  ) -> Result<String> {
    let id = match id {
      Some(uuid) => uuid.into(),
      None => Self::__generate_uuid(),
    };

    // Create pipeline for async transaction
    let mut pipe = redis::pipe();

    // Insert indexes
    match self.__insert_search_indexes(&mut pipe, id.clone(), search_indexes.clone(), expire_seconds) {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to insert indexes: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    }

    // Insert record
    match self.__insert_record(&mut pipe, id.clone(), value, expire_seconds) {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to insert record: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    }

    // Execute the pipeline
    match pipe.exec_async(&mut self.db_con).await {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to execute Redis pipeline: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(id)
  }

  /// Batch insert record
  pub async fn batch_insert<T: Message + Default>(
    &mut self,
    records: HashMap<Option<String>, T>,
    search_indexes: Vec<String>,
    expire_seconds: Option<i64>,
  ) -> Result<Vec<String>> {
    let mut ids = Vec::new();
    let mut pipe = redis::pipe();

    for (id_opt, record) in records.iter() {
      let id: String = match id_opt {
        Some(id) => id.clone(),
        None => Self::__generate_uuid(),
      };
      ids.push(id.clone());

      // Insert indexes
      match self.__insert_search_indexes(&mut pipe, id.clone(), search_indexes.clone(), expire_seconds) {
        Ok(_) => (),
        Err(e) => {
          log::error!("Failed to insert indexes: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      }

      // Insert record
      match self.__insert_record(&mut pipe, id.clone(), record, expire_seconds) {
        Ok(_) => (),
        Err(e) => {
          log::error!("Failed to insert record: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      }
    }

    // Execute the pipeline
    match pipe.exec_async(&mut self.db_con).await {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to execute Redis pipeline: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(ids)
  }

  /// Remove record
  pub async fn remove(&mut self, id: String) -> Result<()> {
    let mut pipe = redis::pipe();

    // Remove indexes
    match self.__remove_search_indexes(&mut pipe, id.to_string()).await {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to remove indexes: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    }

    // Remove record
    match self.__remove_record(&mut pipe, id.to_string()) {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to remove record: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    }

    // Execute the pipeline
    match pipe.exec_async(&mut self.db_con).await {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to execute Redis pipeline: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(())
  }

  /// Batch remove record
  pub async fn batch_remove(&mut self, ids: Vec<String>) -> Result<()> {
    let mut pipe = redis::pipe();

    for id in ids {
      // Remove indexes
      match self.__remove_search_indexes(&mut pipe, id.to_string()).await {
        Ok(_) => (),
        Err(e) => {
          log::error!("Failed to remove indexes: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      }

      // Remove record
      match self.__remove_record(&mut pipe, id.to_string()) {
        Ok(_) => (),
        Err(e) => {
          log::error!("Failed to remove record: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      }
    }

    // Execute the pipeline
    match pipe.exec_async(&mut self.db_con).await {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to execute Redis pipeline: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(())
  }

  /// Get single record by id
  pub async fn get<T: Message + Default>(&mut self, id: String) -> Result<Option<T>> {
    let record = match self.__get_record::<T>(id).await {
      Ok(r) => r,
      Err(e) => {
        log::error!("Failed to get record: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(record)
  }

  /// Get multiple records by ids
  pub async fn batch_get<T: Message + Default>(&mut self, ids: Vec<String>) -> Result<HashMap<String, T>> {
    let records = match self.__get_records::<T>(ids).await {
      Ok(r) => r,
      Err(e) => {
        log::error!("Failed to get records: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(records)
  }

  // Get all records
  pub async fn get_all_ids(&mut self) -> Result<Vec<String>> {
    // Pattern to match all data keys
    let pattern = format!("{}:{}:*", self.name, DATA_PREFIX);

    // AsyncIter handles cursor automatically
    let mut record_ids: Vec<String> = Vec::new();
    let mut iter = match self.db_con.scan_match::<String, String>(pattern).await {
      Ok(it) => it,
      Err(e) => {
        log::error!("Failed to scan keys: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    while let Some(key) = iter.next_item().await {
      let key = match key {
        Ok(k) => k,
        Err(e) => {
          log::error!("Failed to scan keys: {}", e);
          return Err(anyhow::anyhow!(e));
        }
      };
      // Extract record id from key
      if let Some(id) = key.split(':').last() {
        record_ids.push(id.to_string());
      }
    }

    // extract id from key

    Ok(record_ids)
  }

  // Get record ids by single searchable field
  pub async fn get_by_search_index<T: Message + Default>(
    &mut self,
    search_index: String,
  ) -> Result<HashMap<String, T>> {
    let record_ids = match self.__get_record_ids_single_sid(search_index).await {
      Ok(r) => r,
      Err(e) => {
        log::error!("Failed to get record ids: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    let records: HashMap<String, T> = match self.__get_records::<T>(record_ids).await {
      Ok(r) => r,
      Err(e) => {
        log::error!("Failed to get records: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(records)
  }

  // Get records by searchable field
  pub async fn batch_get_by_search_index<T: Message + Default>(
    &mut self,
    search_indexes: Vec<String>,
  ) -> Result<HashMap<String, T>> {
    let record_ids = match self.__get_record_ids_multi_sid(search_indexes).await {
      Ok(r) => r,
      Err(e) => {
        log::error!("Failed to get record ids: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    let records: HashMap<String, T> = match self.__get_records::<T>(record_ids).await {
      Ok(r) => r,
      Err(e) => {
        log::error!("Failed to get records: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    Ok(records)
  }

  // Get mu
}
