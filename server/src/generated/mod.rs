#[allow(clippy::all, clippy::pedantic)]
pub mod api {
  include!("reflink.api.rs");
}

#[allow(clippy::all, clippy::pedantic)]
pub mod db {
  include!("reflink.db.rs");
}
#[allow(clippy::all, clippy::pedantic)]
pub mod common {
  include!("reflink.common.rs");
}
#[allow(clippy::all, clippy::pedantic)]
pub mod fms {
  include!("reflink.fms.rs");
}
