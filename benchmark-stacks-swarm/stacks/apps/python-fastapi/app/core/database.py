from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import declarative_base, sessionmaker
import os

DB_URL = os.getenv("DB_URL", "postgresql+asyncpg://postgres:postgres@localhost:6432/benchmark?application_name=fastapi-benchmark")

# engine = create_async_engine(DB_URL, pool_size=int(os.getenv("DB_MAX_POOL_SIZE", "15")), max_overflow=0})
engine = create_async_engine(DB_URL, pool_size=int(os.getenv("DB_MAX_POOL_SIZE", "15")), max_overflow=20)

AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
