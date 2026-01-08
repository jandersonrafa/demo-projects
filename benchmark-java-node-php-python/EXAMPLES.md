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
    "description": "Welcome Bonus",
    "clientId": "user-123"
  }'
```

### Get Bonus
```bash
curl http://localhost:3005/bonus/1
```

## 2. Java WebFlux
**Port:** 3006

### Create Bonus
```bash
curl -X POST http://localhost:3006/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 250.00,
    "description": "Loyalty Bonus",
    "clientId": "user-456"
  }'
```

### Get Bonus
```bash
curl http://localhost:3006/bonus/1
```

## 3. Java MVC Virtual Threads
**Port:** 3007

### Create Bonus
```bash
curl -X POST http://localhost:3007/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 500.00,
    "description": "VIP Bonus",
    "clientId": "user-789"
  }'
```

### Get Bonus
```bash
curl http://localhost:3007/bonus/1
```

## 4. Python FastAPI
**Port:** 3008

### Create Bonus
```bash
curl -X POST http://localhost:3008/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 75.00,
    "description": "Referral Bonus",
    "clientId": "user-101"
  }'
```

### Get Bonus
```bash
curl http://localhost:3008/bonus/1
```

## 5. PHP Laravel
**Port:** 3009

### Create Bonus
```bash
curl -X POST http://localhost:3009/bonus \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 10.00,
    "description": "Signup Bonus",
    "clientId": "user-202"
  }'
```

### Get Bonus
```bash
curl http://localhost:3009/bonus/1
```
