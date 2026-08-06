from pydantic import BaseModel
from enum import Enum

class ColesterolEnum(str, Enum):
    NORMAL= "Normal"
    ELEVADO= "Elevado"
    ALTO= "Alto"

class ActividadEnum(str, Enum):
    ACTIVO="Activo"
    SEDENTARIO="Sedentario"



class GlucosaEnum(str, Enum):
    NORMAL= "Normal"
    ELEVADO= "Elevado"
    MUY_ELEVADA= "Muy elevada"


class HistorialCreate(BaseModel):

    id_usuario:int

    colesterol:ColesterolEnum

    glucosa:GlucosaEnum

    presion_sistolica:int

    presion_diastolica:int

    diabetes:bool

    fuma:bool

    alcohol:bool

    actividad:ActividadEnum

    peso:float

    estatura:float



class HistorialResponse(HistorialCreate):

    id_historial:int


    class Config:
        from_attributes=True