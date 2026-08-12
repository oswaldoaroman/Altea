import httpx

from fastapi import APIRouter, HTTPException

from database.ollama_config import MODEL_NAME, OLLAMA_API_URL
from schemas.ollama import PromptRequest, OllamaResponse


router = APIRouter(
    prefix="/ollama",
    tags=["Ollama"]
)


@router.post("/ask", response_model=OllamaResponse)
def ask_ollama(request: PromptRequest):

    print(f"Prompt recibido: {request.prompt}")

    payload = {
        "model": MODEL_NAME,
        "prompt": request.prompt,
        "stream": request.stream
    }

    try:
        response = httpx.post(
            OLLAMA_API_URL,
            json=payload,
            timeout=120.0
        )

        response.raise_for_status()

        data = response.json()

        result = data.get("response")

        if not result:
            raise HTTPException(
                status_code=500,
                detail="Ollama no devolvió una respuesta válida."
            )

        return {
            "result": result
        }

    except httpx.ConnectError:
        raise HTTPException(
            status_code=503,
            detail=(
                "No se pudo conectar con Ollama. "
                "Asegúrate de que el servidor esté ejecutándose."
            )
        )

    except httpx.TimeoutException:
        raise HTTPException(
            status_code=504,
            detail="Ollama tardó demasiado en responder."
        )

    except httpx.HTTPStatusError as e:
        raise HTTPException(
            status_code=502,
            detail=(
                f"Ollama devolvió un error HTTP: "
                f"{e.response.status_code}"
            )
        )

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error inesperado: {str(e)}"
        )

