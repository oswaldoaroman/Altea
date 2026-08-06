from sqlalchemy import Column, DateTime, Integer, String, Date, func
from database.connection import Base



class Usuario(Base):

    __tablename__ = "usuarios"


    id_usuario = Column(
        Integer,
        primary_key=True
    )
    nombre = Column(
        String(100)
    )
    correo = Column(
        String(100)
    )
    password_hash = Column(
        String(255)
    )
    fecha_nacimiento = Column(
        Date
    )
    genero = Column(
        String(20)
    )
    fecha_registro = Column(
        DateTime,
        server_default=func.now()
    )