# Installing / updating RefLink on a bare host (no Docker)

This project's `Dockerfile`/`docker-compose.yml` assume Docker, but Docker is
avoided on Proxmox LXC containers (nested container/overlayfs issues). These
are the steps to build and run the server directly on the host with systemd
instead.

Tested on Ubuntu 24.04. Assumes you're root (adjust `sudo` usage otherwise).

## First-time install

1. **System dependencies**

   ```bash
   apt-get update
   apt-get install -y protobuf-compiler redis-server
   ```

   - `protobuf-compiler` provides `protoc`, required by `server/build.rs`
     (via `tonic-prost-build`) to compile the `.proto` files in `protos/`.
   - `redis-server` is a hard runtime dependency (`REDIS_URL`, default
     `redis://127.0.0.1/`) — in the Docker setup this ran as a sidecar
     container; here it runs as its own systemd service on localhost only.
     The apt package enables and starts it automatically.

2. **Rust toolchain** — install via [rustup](https://rustup.rs) if not
   already present. This was built/tested with rustc 1.97.1.

3. **Build the release binary**

   ```bash
   cd /root/RefLink
   cargo build --release -p server
   ```

   Output binary: `target/release/server`.

4. **Configure environment**

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and fill in the real FMS (Cheesy Arena) values for this
   deployment: `FMS_HOST`, `FMS_PORT`, `FMS_DISPLAY_ID`, `FMS_ADMIN_PASSWORD`.
   These are read via clap `env` args in `server/src/config.rs`; `REDIS_URL`
   can also be overridden here if Redis isn't local.

5. **Install the systemd service**

   ```bash
   cp reflink.service /etc/systemd/system/reflink.service
   systemctl daemon-reload
   systemctl enable --now reflink
   ```

6. **Verify**

   ```bash
   systemctl status reflink
   journalctl -u reflink -f
   redis-cli ping   # should return PONG
   ```

   The gRPC API listens on `0.0.0.0:50051` by default (`--api-port` /
   `config.rs`).

## Updating after a code change

From the project directory (`/root/RefLink` by default):

```bash
git pull                       # or however you get the new source
cargo build --release -p server
systemctl restart reflink
```

`cargo build` overwrites `target/release/server` in place, and `restart`
picks up the new binary. No need to touch the service file unless its
contents changed (see below).

If `reflink.service` itself changed (e.g. you edit the copy in this repo):

```bash
cp reflink.service /etc/systemd/system/reflink.service
systemctl daemon-reload
systemctl restart reflink
```

## Installing to a different path

If you clone/deploy this repo somewhere other than `/root/RefLink`, update
the three absolute paths in `reflink.service` before copying it in:

- `WorkingDirectory=`
- `ExecStart=` (points at `<repo>/target/release/server`)
- `EnvironmentFile=` (points at `<repo>/.env`)

Everything else (build steps, apt packages, enable/restart commands) stays
the same regardless of install path.

## Uninstalling

```bash
systemctl disable --now reflink
rm /etc/systemd/system/reflink.service
systemctl daemon-reload
```

Redis is left running since it may be shared with other services; remove it
separately with `apt-get purge redis-server` if it's no longer needed.
