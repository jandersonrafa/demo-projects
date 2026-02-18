FROM rust:alpine AS builder
RUN apk add --no-cache musl-dev openssl-dev pkgconfig perl g++ make cmake
WORKDIR /app
COPY . .
RUN cargo build --release

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/target/release/gateway .
EXPOSE 3000
CMD ["./gateway"]
