import httpx
from fastapi import FastAPI
from contextlib import asynccontextmanager
from prometheus_fastapi_instrumentator import Instrumentator, metrics
from prometheus_client import PROCESS_COLLECTOR, PLATFORM_COLLECTOR, REGISTRY, CollectorRegistry, multiprocess, generate_latest, CONTENT_TYPE_LATEST
import os
import shutil
from fastapi import Response

# Import the bonus router
from app.routes import bonus

# Ensure multiprocess directory exists before Instrumentator initialization
multiproc_dir = os.environ.get("PROMETHEUS_MULTIPROC_DIR")
if multiproc_dir:
    # We don't clean it here because each worker would wipe others' metrics
    # Cleaning should happen in a separate process or we just rely on fresh starts
    os.makedirs(multiproc_dir, exist_ok=True)

# Register collectors
try:
    REGISTRY.register(PROCESS_COLLECTOR)
    REGISTRY.register(PLATFORM_COLLECTOR)
except ValueError:
    # Collectors may already be registered
    pass

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Setup: Create a single client for connection pooling
    limits = httpx.Limits(max_connections=500, max_keepalive_connections=100)
    timeout = httpx.Timeout(30.0, connect=15.0)
    
    async with httpx.AsyncClient(limits=limits, timeout=timeout) as client:
        app.state.client = client
        yield
    # Teardown: Client is closed when the context manager exits

# Create the FastAPI app
app = FastAPI(lifespan=lifespan)

# Instrument the app with Prometheus
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

# Include the bonus router
app.include_router(bonus.router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)