# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o monolith cmd/server/main.go

# Run stage
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/monolith .

EXPOSE 3000

CMD ["./monolith"]
