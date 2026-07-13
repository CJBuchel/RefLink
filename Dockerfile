# syntax=docker/dockerfile:1

FROM rust:1.88 AS chef
RUN cargo install cargo-chef
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

COPY . .
RUN cargo build --release -p server

FROM debian:bookworm-slim
WORKDIR /app

COPY --from=builder /app/target/release/server .

CMD ["./server"]
