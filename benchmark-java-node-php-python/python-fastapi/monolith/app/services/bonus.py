from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from fastapi import HTTPException
from decimal import Decimal
from datetime import datetime, timedelta
from app.models.bonus import Bonus
from app.models.client import Client
from app.schemas.bonus import BonusCreate

class BonusService:
    @staticmethod
    async def create_bonus(session: AsyncSession, bonus_data: BonusCreate) -> Bonus:
        # 1. Validation: Amount must be positive
        if bonus_data.amount <= 0:
            raise HTTPException(status_code=400, detail="Amount must be positive")

        # 2. Integrity Check: Client exists and is active
        result = await session.execute(select(Client).where(Client.id == bonus_data.clientId))
        db_client = result.scalar_one_or_none()
        if not db_client:
            raise HTTPException(status_code=404, detail="Client not found")
        if not db_client.active:
            raise HTTPException(status_code=400, detail="Client is inactive")

        # 3. Biz Logic: Multiplier and Expiration
        final_amount = bonus_data.amount
        if final_amount > 100:
            final_amount = final_amount * Decimal("1.1")
        
        expiration_date = datetime.utcnow() + timedelta(days=30)

        db_bonus = Bonus(
            amount=final_amount,
            description="PYTHONFASTAPI - " + bonus_data.description,
            clientId=bonus_data.clientId,
            expirationDate=expiration_date
        )
        session.add(db_bonus)
        await session.commit()
        await session.refresh(db_bonus)
        return db_bonus

    @staticmethod
    async def get_bonus(session: AsyncSession, id: int) -> Bonus:
        result = await session.execute(select(Bonus).where(Bonus.id == id))
        db_bonus = result.scalar_one_or_none()
        if db_bonus is None:
            raise HTTPException(status_code=404, detail="Bonus not found")
        return db_bonus
