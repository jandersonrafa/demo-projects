from sqlalchemy import Column, Integer, Numeric, String, DateTime, Boolean
from datetime import datetime
from app.core.database import Base

class Client(Base):
    __tablename__ = "clients"
    id = Column(String, primary_key=True, index=True)
    name = Column(String)
    active = Column(Boolean, default=True)
