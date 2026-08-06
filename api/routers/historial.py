from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database.connection import get_db
from models.historial import HistorialMedico
from schemas.historial import (
    HistorialCreate,
    HistorialResponse
)

router = APIRouter(
    prefix="/historial",
    tags=["Historial Médico"]
)


@router.get("/", response_model=list[HistorialResponse])
def obtener_historial(db: Session = Depends(get_db)):

    return db.query(HistorialMedico).all()


@router.get("/{id_historial}", response_model=HistorialResponse)
def obtener_historial_id(
    id_historial: int,
    db: Session = Depends(get_db)
):

    historial = db.query(HistorialMedico).filter(
        HistorialMedico.id_historial == id_historial
    ).first()

    if historial is None:
        raise HTTPException(
            status_code=404,
            detail="Historial no encontrado"
        )

    return historial


@router.post("/", response_model=HistorialResponse)
def crear_historial(
    datos: HistorialCreate,
    db: Session = Depends(get_db)
):

    historial = HistorialMedico(
        **datos.model_dump()
    )

    db.add(historial)
    db.commit()
    db.refresh(historial)

    return historial


@router.delete("/{id_historial}")
def eliminar_historial(
    id_historial: int,
    db: Session = Depends(get_db)
):

    historial = db.query(HistorialMedico).filter(
        HistorialMedico.id_historial == id_historial
    ).first()

    if historial is None:
        raise HTTPException(
            status_code=404,
            detail="Historial no encontrado"
        )

    db.delete(historial)
    db.commit()

    return {
        "mensaje": "Historial eliminado"
    }