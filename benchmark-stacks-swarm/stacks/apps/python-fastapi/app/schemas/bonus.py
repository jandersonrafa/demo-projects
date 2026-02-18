from pydantic import BaseModel
from decimal import Decimal
from typing import Optional
from datetime import datetime

class BonusCreate(BaseModel):
    amount: Decimal
    description: str
    clientId: str

    class Config:
        json_schema_extra = {
            "example": {
                "amount": 105.50,
                "description": "Quarterly Bonus",
                "clientId": "client_1"
            }
        }

class BonusResponse(BaseModel):
    id: int
    amount: float
    description: str
    clientId: str
    createdAt: datetime
    expirationDate: Optional[datetime]

    class Config:
        from_attributes = True
        # Map snake_case database columns to camelCase Pydantic fields if necessary, 
        # but here they are already matching or using Column aliases in SQLAlchemy.
