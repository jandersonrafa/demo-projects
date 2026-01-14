from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_db
from app.schemas.bonus import BonusCreate, BonusResponse
from app.services.bonus import BonusService

router = APIRouter(prefix="/bonus", tags=["bonus"])

@router.post("", response_model=BonusResponse, status_code=status.HTTP_201_CREATED)
async def create_bonus(bonus: BonusCreate, db: AsyncSession = Depends(get_db)):
    return await BonusService.create_bonus(db, bonus)

@router.get("/{id}", response_model=BonusResponse)
async def get_bonus(id: int, db: AsyncSession = Depends(get_db)):
    return await BonusService.get_bonus(db, id)
