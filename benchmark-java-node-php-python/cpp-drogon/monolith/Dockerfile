FROM gcc:latest AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    libpq-dev \
    libjsoncpp-dev \
    libpqxx-dev \
    pkg-config \
    git \
    uuid-dev \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build Drogon
RUN git clone https://github.com/an-tao/drogon.git /tmp/drogon && \
    cd /tmp/drogon && \
    git checkout v1.9.9 && \
    git submodule update --init --recursive && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install

WORKDIR /app
COPY CMakeLists.txt ./
COPY src ./src
COPY include ./include
COPY config.json ./

RUN mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc)

FROM gcc:latest

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libpq5 \
    libjsoncpp26 \
    libpqxx-dev \
    libbrotli1 \
    libuuid1 \
    zlib1g \
    libmariadb3 \
    libsqlite3-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/build/monolith ./
COPY --from=builder /usr/local/lib/libdrogon* /usr/local/lib/
COPY --from=builder /app/config.json ./

RUN ldconfig

EXPOSE 3000
CMD ["./monolith"]
