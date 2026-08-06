from datetime import datetime

from pydantic import BaseModel

from enum import Enum

class RiesgoEnum(str, Enum):
    BAJO="Bajo"
    MEDIO="Medio"
    Alto="Alto"


class ResultadoCreate(BaseModel):

    id_historial: int
    probabilidad: float
    riesgo: RiesgoEnum
    modelo: str


class ResultadoResponse(BaseModel):

    id_resultado: int
    id_historial: int

    probabilidad: float
    riesgo: RiesgoEnum
    modelo: str

    fecha_resultado: datetime

    class Config:
        from_attributes = True