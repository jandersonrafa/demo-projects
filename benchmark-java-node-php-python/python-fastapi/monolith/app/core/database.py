from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import declarative_base, sessionmaker
import os

DB_URL = os.getenv("DB_URL", "postgresql+asyncpg://postgres:postgres@localhost:5432/benchmark?application_name=fastapi-benchmark")

# engine = create_async_engine(DB_URL, pool_size=15, max_overflow=0})
engine = create_async_engine(DB_URL, pool_size=15, max_overflow=10)

AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
