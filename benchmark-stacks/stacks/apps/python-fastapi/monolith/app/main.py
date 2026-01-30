from contextlib import asynccontextmanager
from app.routes import bonus_router, metrics_router, health_router
from prometheus_fastapi_instrumentator import Instrumentator, metrics
from prometheus_client import PROCESS_COLLECTOR, PLATFORM_COLLECTOR, REGISTRY, CollectorRegistry, multiprocess, generate_latest, CONTENT_TYPE_LATEST, Gauge
import os
import shutil
import psutil
import threading
import time
from fastapi import Response, FastAPI

# Ensure multiprocess directory exists before Instrumentator initialization
multiproc_dir = os.environ.get("PROMETHEUS_MULTIPROC_DIR")
if multiproc_dir:
    os.makedirs(multiproc_dir, exist_ok=True)

# Unregister default collectors to avoid conflicts with our custom multiprocess Gauge
try:
    REGISTRY.unregister(PROCESS_COLLECTOR)
    REGISTRY.unregister(PLATFORM_COLLECTOR)
except Exception:
    pass

# Custom Gauge for RSS memory in multiprocess mode
PROCESS_RSS = Gauge(
    "process_resident_memory_bytes",
    "Resident memory size in bytes",
    multiprocess_mode="livesum",
)

# Custom Gauge for CPU seconds in multiprocess mode
PROCESS_CPU = Gauge(
    "process_cpu_seconds_total",
    "Total user and system CPU time spent in seconds",
    multiprocess_mode="livesum",
)

def update_metrics():
    process = psutil.Process(os.getpid())
    while True:
        try:
            # Memory
            PROCESS_RSS.set(process.memory_info().rss)
            # CPU (User + System time)
            cpu_times = process.cpu_times()
            PROCESS_CPU.set(cpu_times.user + cpu_times.system)
        except Exception:
            pass
        time.sleep(1)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Start background thread to update metrics
    rss_thread = threading.Thread(target=update_metrics, daemon=True)
    rss_thread.start()
    yield


app = FastAPI(title="Benchmark Monolith - Python FastAPI", lifespan=lifespan)

Instrumentator().add(
    metrics.requests()
).add(
    metrics.latency(buckets=(0.001, 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10))
).instrument(app)

app.include_router(bonus_router)
app.include_router(metrics_router)
app.include_router(health_router)
