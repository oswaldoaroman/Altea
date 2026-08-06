from sqlalchemy import Column,Integer,String,Float,DateTime, func
from database.connection import Base


class Resultado(Base):

    __tablename__="resultados"


    id_resultado = Column(
        Integer,
        primary_key=True
    )


    id_historial = Column(
        Integer
    )


    probabilidad = Column(
        Float
    )


    riesgo = Column(
        String(50)
    )


    modelo = Column(
        String(50)
    )


    fecha_resultado = Column(
    DateTime,
    server_default=func.now()
    )