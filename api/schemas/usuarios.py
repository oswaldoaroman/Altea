from datetime import date
from datetime import datetime
from pydantic import BaseModel, EmailStr
from sqlalchemy import Enum

class GeneroEnum(str, Enum):
    MASCULINO="Masculino"
    FEMENINO="Femenino"

class UsuarioCreate(BaseModel):

    nombre: str
    correo: EmailStr
    password: str
    fecha_nacimiento: date
    genero: str


class UsuarioResponse(BaseModel):

    id_usuario: int
    nombre: str
    correo: EmailStr
    fecha_nacimiento: date
    genero: str
    fecha_resultado:datetime

    class Config:
        from_attributes = True