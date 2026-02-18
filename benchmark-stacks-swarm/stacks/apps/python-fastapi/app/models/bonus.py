from sqlalchemy import Column, Integer, Numeric, String, DateTime
from datetime import datetime
from app.core.database import Base

class Bonus(Base):
    __tablename__ = "bonus"
    id = Column(Integer, primary_key=True, index=True)
    amount = Column(Numeric)
    description = Column(String)
    clientId = Column("client_id", String)
    createdAt = Column("created_at", DateTime, default=datetime.utcnow)
    expirationDate = Column("expiration_date", DateTime)
