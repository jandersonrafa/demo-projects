import httpx
from fastapi import FastAPI
from contextlib import asynccontextmanager
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_client import PROCESS_COLLECTOR, PLATFORM_COLLECTOR, REGISTRY

# Import the bonus router
from app.routes import bonus

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
    async with httpx.AsyncClient() as client:
        app.state.client = client
        yield
    # Teardown: Client is closed when the context manager exits

# Create the FastAPI app
app = FastAPI(lifespan=lifespan)

# Instrument the app with Prometheus
Instrumentator().instrument(app).expose(app)

# Include the bonus router
app.include_router(bonus.router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)