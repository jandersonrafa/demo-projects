from fastapi import FastAPI
from app.api.bonus import router as bonus_router
from prometheus_fastapi_instrumentator import Instrumentator, metrics
from prometheus_client import PROCESS_COLLECTOR, PLATFORM_COLLECTOR, REGISTRY, CollectorRegistry, multiprocess, generate_latest, CONTENT_TYPE_LATEST
import os
import shutil
from fastapi import Response

# Ensure multiprocess directory exists before Instrumentator initialization
multiproc_dir = os.environ.get("PROMETHEUS_MULTIPROC_DIR")
if multiproc_dir:
    os.makedirs(multiproc_dir, exist_ok=True)

# Unregister default collectors if already registered to avoid errors, then register them
try:
    REGISTRY.register(PROCESS_COLLECTOR)
    REGISTRY.register(PLATFORM_COLLECTOR)
except ValueError:
    pass

app = FastAPI(title="Benchmark Monolith - Python FastAPI")

Instrumentator().add(
    metrics.latency(buckets=(0.001, 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10))
).instrument(app)

@app.get("/metrics")
async def metrics_endpoint():
    if "PROMETHEUS_MULTIPROC_DIR" in os.environ:
        registry = CollectorRegistry()
        multiprocess.MultiProcessCollector(registry)
        data = generate_latest(registry)
    else:
        data = generate_latest(REGISTRY)
    return Response(content=data, media_type=CONTENT_TYPE_LATEST)

app.include_router(bonus_router)

@app.get("/health")
async def health():
    return {"status": "up"}
