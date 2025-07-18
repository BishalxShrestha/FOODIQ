from typing import TypeVar, Generic, Optional
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from jose import JWTError, jwt
from auth.config import SECRET_KEY, ALGORITHM

T = TypeVar('T')

# Users repository
class BaseRepo:
    @staticmethod
    def insert(db: Session, model: Generic[T]):
        db.add(model)
        db.commit()
        db.refresh(model)

class UsersRepo(BaseRepo):
    @staticmethod
    def find_by_email(db: Session, model: Generic[T], email: str):
        return db.query(model).filter(model.email == email).first()

# JWT token repository
class JWTRepo:
    @staticmethod
    def generate_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
        to_encode = data.copy()
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=15)
        to_encode.update({'exp': expire})
        encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
        return encoded_jwt

    @staticmethod
    def decode_token(token: str) -> Optional[dict]:
        try:
            decoded_token = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            # The JWT exp claim is automatically verified by jose.jwt.decode,
            # so if this line is reached, token is valid and not expired.
            return decoded_token
        except JWTError:
            return None
