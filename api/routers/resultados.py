from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database.connection import get_db
from models.resultados import Resultado
from schemas.resultados import (
    ResultadoCreate,
    ResultadoResponse
)

router = APIRouter(
    prefix="/resultados",
    tags=["Resultados"]
)


@router.get("/", response_model=list[ResultadoResponse])
def obtener_resultados(db: Session = Depends(get_db)):

    return db.query(Resultado).all()


@router.get("/{id_resultado}", response_model=ResultadoResponse)
def obtener_resultado(
    id_resultado: int,
    db: Session = Depends(get_db)
):

    resultado = db.query(Resultado).filter(
        Resultado.id_resultado == id_resultado
    ).first()

    if resultado is None:
        raise HTTPException(
            status_code=404,
            detail="Resultado no encontrado"
        )

    return resultado


@router.post("/", response_model=ResultadoResponse)
def crear_resultado(
    datos: ResultadoCreate,
    db: Session = Depends(get_db)
):

    resultado = Resultado(
        **datos.model_dump()
    )

    db.add(resultado)
    db.commit()
    db.refresh(resultado)
    print(resultado.__dict__)

    return resultado


@router.delete("/{id_resultado}")
def eliminar_resultado(
    id_resultado: int,
    db: Session = Depends(get_db)
):

    resultado = db.query(Resultado).filter(
        Resultado.id_resultado == id_resultado
    ).first()

    if resultado is None:
        raise HTTPException(
            status_code=404,
            detail="Resultado no encontrado"
        )

    db.delete(resultado)
    db.commit()

    return {
        "mensaje": "Resultado eliminado"
    }