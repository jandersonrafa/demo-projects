FROM rust:alpine AS builder
RUN apk add --no-cache musl-dev openssl-dev pkgconfig perl g++ make cmake
WORKDIR /app
COPY . .
# Clean target if copied, to ensure clean build
RUN rm -rf target
RUN cargo build --release

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/target/release/monolith .
EXPOSE 3000
CMD ["./monolith"]
