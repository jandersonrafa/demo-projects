# Examples of Calls for API Gateways

This document contains examples of `curl` calls to test the different API Gateway implementations in the benchmark project.

Each gateway exposes the same endpoints:
- `POST /bonus` - Create a new bonus
- `GET /bonus/{id}` - Retrieve a bonus by ID

## 1. Node NestJS
**Port:** 3005

### Create Bonus
```bash
curl -X POST http://localhost:3005/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 100.50,
    "description": "Node Bonus",
    "clientId": "user-123"
  }'
```

---

## 2. Java WebFlux
**Port:** 3006

### Create Bonus
```bash
curl -X POST http://localhost:3006/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 250.00,
    "description": "WebFlux Bonus",
    "clientId": "user-456"
  }'
```

---

## 3. Java MVC Virtual Threads
**Port:** 3007

### Create Bonus
```bash
curl -X POST http://localhost:3007/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 500.00,
    "description": "MVC VT Bonus",
    "clientId": "user-789"
  }'
```

---

## 4. Python FastAPI
**Port:** 3008

### Create Bonus
```bash
curl -X POST http://localhost:3008/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 75.00,
    "description": "Python Bonus",
    "clientId": "user-101"
  }'
```

---

## 5. PHP Laravel (CLI)
**Port:** 3009

### Create Bonus
```bash
curl -X POST http://localhost:3009/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 10.00,
    "description": "PHP CLI Bonus",
    "clientId": "user-202"
  }'
```

---

## 6. PHP Laravel FPM
**Port:** 3011

### Create Bonus
```bash
curl -X POST http://localhost:3011/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 150.00,
    "description": "PHP FPM Bonus",
    "clientId": "user-303"
  }'
```

---

## 7. PHP Laravel Octane
**Port:** 3014

### Create Bonus
```bash
curl -X POST http://localhost:3014/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 200.00,
    "description": "PHP Octane Bonus",
    "clientId": "user-404"
  }'
```

---

## 8. Java MVC Traditional
**Port:** 3016

### Create Bonus
```bash
curl -X POST http://localhost:3016/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 300.00,
    "description": "Java MVC Bonus",
    "clientId": "user-505"
  }'
```

---

## 9. Golang Gin
**Port:** 3018

### Create Bonus
```bash
curl -X POST http://localhost:3018/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 400.00,
    "description": "Golang Bonus",
    "clientId": "user-606"
  }'
```

---

## 10. .NET Core
**Port:** 3020

### Create Bonus
```bash
curl -X POST http://localhost:3020/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 500.00,
    "description": ".NET Bonus",
    "clientId": "user-707"
  }'
```

---

## 11. C++ Drogon
**Port:** 3022

### Create Bonus
```bash
curl -X POST http://localhost:3022/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 600.00,
    "description": "C++ Bonus",
    "clientId": "user-808"
  }'
```

---

## 12. Rust Axum
**Port:** 3024

### Create Bonus
```bash
curl -X POST http://localhost:3024/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 700.00,
    "description": "Rust Bonus",
    "clientId": "user-909"
  }'
```
