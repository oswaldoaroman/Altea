from sqlalchemy import Column, DateTime,Integer,String,Boolean,Float,Date
from database.connection import Base



class HistorialMedico(Base):

    __tablename__="historial_medico"


    id_historial = Column(
        Integer,
        primary_key=True
    )
    id_usuario = Column(
        Integer
    )


    colesterol = Column(
        String(50)
    )


    glucosa = Column(
        String(50)
    )


    presion_sistolica = Column(
        Integer
    )


    presion_diastolica = Column(
        Integer
    )


    diabetes = Column(
        Boolean
    )


    fuma = Column(
        Boolean
    )


    alcohol = Column(
        Boolean
    )


    actividad = Column(
        String(50)
    )


    peso = Column(
        Float
    )


    estatura = Column(
        Float
    )


    fecha_evaluacion = Column(
        DateTime
    )