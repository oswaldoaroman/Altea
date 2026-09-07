import json

import httpx
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from database.ollama_config import OLLAMA_URL, OLLAMA_MODEL, SYSTEM_PROMPT

router = APIRouter(
    prefix="/ollama",
    tags=["Ollama"]
)

@router.websocket("/ws")
async def ollama_websocket(websocket: WebSocket):

    await websocket.accept()

    print("Cliente WebSocket conectado.")

    try:

        while True:

            # ------------------------------------------------
            # Recibir mensaje desde Flutter
            # ------------------------------------------------

            message = await websocket.receive_text()

            try:
                data = json.loads(message)

            except json.JSONDecodeError:

                await websocket.send_json({
                    "type": "error",
                    "message": "El mensaje recibido no es JSON válido."
                })

                continue

            prompt = data.get("prompt")

            if not prompt:

                await websocket.send_json({
                    "type": "error",
                    "message": "El prompt no puede estar vacío."
                })

                continue

            # ------------------------------------------------
            # Preparar petición a Ollama
            # ------------------------------------------------

            payload = {
                "model": OLLAMA_MODEL,

                # IMPORTANTE:
                # Mantiene la personalidad de Altea
                "system": SYSTEM_PROMPT,

                "prompt": prompt,
                "stream": True
            }

            # ------------------------------------------------
            # Conectarse a Ollama
            # ------------------------------------------------

            try:

                async with httpx.AsyncClient(timeout=None) as client:

                    async with client.stream(
                        "POST",
                        OLLAMA_URL,
                        json=payload
                    ) as response:

                        if response.status_code != 200:

                            error_body = await response.aread()

                            await websocket.send_json({
                                "type": "error",
                                "message": (
                                    "Error de Ollama: "
                                    f"{error_body.decode()}"
                                )
                            })

                            continue

                        # ------------------------------------
                        # Leer streaming de Ollama
                        # ------------------------------------

                        async for line in response.aiter_lines():

                            if not line:
                                continue

                            try:

                                ollama_data = json.loads(line)

                            except json.JSONDecodeError:

                                continue

                            # --------------------------------
                            # Obtener fragmento
                            # --------------------------------

                            chunk = ollama_data.get(
                                "response",
                                ""
                            )

                            if chunk:

                                await websocket.send_json({
                                    "type": "chunk",
                                    "content": chunk
                                })

                            # --------------------------------
                            # Ollama terminó
                            # --------------------------------

                            if ollama_data.get("done") is True:

                                await websocket.send_json({
                                    "type": "done"
                                })

                                break

            except Exception as e:

                print(
                    f"Error comunicándose con Ollama: {e}"
                )

                await websocket.send_json({
                    "type": "error",
                    "message": "No se pudo comunicar con Ollama."
                })

    except WebSocketDisconnect:

        print("Cliente WebSocket desconectado.")

    except Exception as e:

        print(f"Error WebSocket: {e}")

    finally:

        print("Conexión WebSocket finalizada.")

