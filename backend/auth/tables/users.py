from sqlalchemy import Column,Integer,String,Boolean,DateTime
from auth.config import Base
import datetime

class Users(Base):
    __tablename__ ='users'

    id = Column(Integer,primary_key=True,index=True)
    username=Column(String)
    password=Column(String)
    email=Column(String,unique=True,index=True)
    phone_number= Column(String)

    firstname=Column(String)
    lastname=Column(String)
    
    create_data = Column(DateTime, default=datetime.datetime.now())
    update_date = Column(DateTime, onupdate=datetime.datetime) 
