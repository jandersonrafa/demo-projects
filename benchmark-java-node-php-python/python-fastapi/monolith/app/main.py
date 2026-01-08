from fastapi import FastAPI
from app.api.bonus import router as bonus_router
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_client import PROCESS_COLLECTOR, PLATFORM_COLLECTOR, REGISTRY

# Unregister default collectors if already registered to avoid errors, then register them
try:
    REGISTRY.register(PROCESS_COLLECTOR)
    REGISTRY.register(PLATFORM_COLLECTOR)
except ValueError:
    pass

app = FastAPI(title="Benchmark Monolith - Python FastAPI")

Instrumentator().instrument(app).expose(app)

app.include_router(bonus_router)

@app.get("/health")
async def health():
    return {"status": "up"}
