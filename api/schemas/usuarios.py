from datetime import date
from datetime import datetime
from pydantic import BaseModel, ConfigDict, EmailStr
from enum import Enum


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
    fecha_registro: datetime

    model_config = ConfigDict(from_attributes=True)