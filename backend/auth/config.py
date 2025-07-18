from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

DATABASE_URL ="postgresql://postgres:admin@localhost:5432/foodiq"

engine= create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autoflush=False,autocommit=False,bind=engine)
Base=declarative_base()

def get_db():
    db= SessionLocal()
    try:
        yield db
    finally:db.close()


#jwt
SECRET_KEY = "admin"
ALGORITHM ="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES =30
