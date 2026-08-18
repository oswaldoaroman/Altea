from fastapi import FastAPI

from routers import (
    usuarios,
    historial,
    resultados,
    ollama
)

app = FastAPI(
    title="Altea API",
    version="1.0.1"
)

app.include_router(usuarios.router)
app.include_router(historial.router)
app.include_router(resultados.router)
app.include_router(ollama.router)

@app.get("/")
def inicio():

    return {
        "mensaje": "API de Altea funcionando"
    }