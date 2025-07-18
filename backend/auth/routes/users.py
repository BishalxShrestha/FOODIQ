from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from auth.models.users import ResponseSchema, TokenResponse, Register, Login
from auth.config import get_db
from passlib.context import CryptContext
from auth.repository.user import UsersRepo, JWTRepo
from auth.tables.users import Users
import traceback

router = APIRouter(
    tags=["Authentication"]
)

pwd_context = CryptContext(schemes=['bcrypt'], deprecated="auto")


# Register Endpoint
@router.post('/signup')
async def signup(request: Register, db: Session = Depends(get_db)):
    try:
        # Check if user already exists
        existing_email = UsersRepo.find_by_email(db, Users, request.email)
        if existing_email:
            raise HTTPException(status_code=400, detail="Email already exists")

        # Create new user object
        _user = Users(
            username=request.username,
            password=pwd_context.hash(request.password),
            email=request.email,
            phone_number=request.phone_number,
            firstname=request.firstname,
            lastname=request.lastname,
        )

        UsersRepo.insert(db, _user)

        return ResponseSchema(
            code="200",
            status="ok",
            message="Successfully registered"
        ).dict(exclude_none=True)

    except Exception as error:
        traceback.print_exc()
        return ResponseSchema(
            code="500",
            status="Error",
            message="Internal server error"
        ).dict(exclude_none=True)


# Login Endpoint
@router.post("/login")
async def login(request: Login, db: Session = Depends(get_db)):
    try:
        _user = UsersRepo.find_by_email(db, Users, request.email)

        if _user is None:
            return ResponseSchema(
                code="400",
                status="Bad Request",
                message="User not found"
            ).dict(exclude_none=True)

        if not pwd_context.verify(request.password, _user.password):
            return ResponseSchema(
                code="400",
                status="Bad Request",
                message="Invalid password"
            ).dict(exclude_none=True)

        token = JWTRepo.generate_token({'sub': _user.email})
        return ResponseSchema(
            code="200",
            status="ok",
            message="Login successful",
            result=TokenResponse(access_token=token, token_type="bearer").dict(exclude_none=True)
        )

    except Exception as error:
        traceback.print_exc()
        return ResponseSchema(
            code="500",
            status="Error",
            message=f"Internal server error: {error}"
        ).dict(exclude_none=True)
