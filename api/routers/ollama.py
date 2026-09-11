import json

import httpx

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from database.ollama_config import (
    OLLAMA_URL,
    OLLAMA_MODEL,
    SYSTEM_PROMPT,
)

router = APIRouter(
    prefix="/ollama",
    tags=["Ollama"],
)


# ==========================================================
# ESTADO DE CONVERSACIÓN
# ==========================================================

class ConversationState:

    def __init__(self):
        self.evaluacion_activa = False

        self.datos_evaluacion = {
            "fuma": None,
            "consumeAlcohol": None,
            "actividadFisica": None,
            "presionSistolica": None,
            "presionDiastolica": None,
            "glucosa": None,
            "colesterol": None,
            "peso": None,
            "altura": None,
        }


# ==========================================================
# WEBSOCKET
# ==========================================================

@router.websocket("/ws")
async def ollama_websocket(websocket: WebSocket):

    await websocket.accept()

    print("Cliente WebSocket conectado.")

    estado = ConversationState()

    try:

        while True:

            # ==================================================
            # RECIBIR MENSAJE
            # ==================================================

            message = await websocket.receive_text()

            try:
                data = json.loads(message)

            except json.JSONDecodeError:

                await websocket.send_json({
                    "type": "error",
                    "message": "El mensaje recibido no es JSON válido."
                })

                continue

            tipo = data.get("type")

            if tipo != "message":

                await websocket.send_json({
                    "type": "error",
                    "message": "Tipo de mensaje no válido."
                })

                continue

            content = data.get("content")

            if not content or not content.strip():

                await websocket.send_json({
                    "type": "error",
                    "message": "El mensaje no puede estar vacío."
                })

                continue

            # ==================================================
            # PROMPT
            # ==================================================

            prompt = f"""
{SYSTEM_PROMPT}

ESTADO ACTUAL DE LA EVALUACIÓN:

Evaluación activa:
{estado.evaluacion_activa}

Datos recopilados:

{json.dumps(
    estado.datos_evaluacion,
    ensure_ascii=False,
    indent=2
)}

REGLAS:

1. Mantén una conversación natural en español.

2. Si el usuario quiere realizar una evaluación,
   inicia el proceso de evaluación.

3. Durante una evaluación debes recopilar únicamente
   los datos necesarios.

4. Cuando el usuario proporcione un dato de evaluación,
   debes generar una instrucción estructurada.

5. No inventes datos.

6. No determines el nivel de riesgo.

7. No calcules el resultado médico.

8. El resultado será calculado por la aplicación
   mediante su Decision Tree local.

FORMATO PARA DATOS:

Cuando obtengas un dato válido utiliza exactamente:

<EVAL_DATA>
{{
    "field": "nombre_del_campo",
    "value": valor
}}
</EVAL_DATA>

Ejemplo:

<EVAL_DATA>
{{
    "field": "fuma",
    "value": true
}}
</EVAL_DATA>

Si acabas de obtener todos los datos necesarios:

<EVAL_COMPLETE>

No muestres estas etiquetas al usuario.

CONVERSACIÓN:

Usuario:
{content}
"""

            # ==================================================
            # PETICIÓN A OLLAMA
            # ==================================================

            payload = {
                "model": OLLAMA_MODEL,
                "prompt": prompt,
                "stream": True,
            }

            try:

                async with httpx.AsyncClient(
                    timeout=None
                ) as client:

                    async with client.stream(
                        "POST",
                        OLLAMA_URL,
                        json=payload,
                    ) as response:

                        if response.status_code != 200:

                            error_body = await response.aread()

                            await websocket.send_json({
                                "type": "error",
                                "message": (
                                    "Error de Ollama: "
                                    f"{error_body.decode()}"
                                ),
                            })

                            continue

                        respuesta_completa = ""

                        # ==================================================
                        # STREAMING
                        # ==================================================

                        async for line in response.aiter_lines():

                            if not line:
                                continue

                            try:
                                ollama_data = json.loads(line)

                            except json.JSONDecodeError:
                                continue

                            chunk = ollama_data.get(
                                "response",
                                ""
                            )

                            if chunk:

                                respuesta_completa += chunk

                                # ------------------------------------------
                                # Ocultar instrucciones internas
                                # ------------------------------------------

                                texto_visible = chunk

                                await websocket.send_json({
                                    "type": "chunk",
                                    "content": texto_visible,
                                })

                            if ollama_data.get("done") is True:
                                break

                        # ==================================================
                        # PROCESAR EVENTOS DE EVALUACIÓN
                        # ==================================================

                        await procesar_eventos_evaluacion(
                            respuesta_completa,
                            estado,
                            websocket,
                        )

                        # ==================================================
                        # FIN
                        # ==================================================

                        await websocket.send_json({
                            "type": "done"
                        })

            except Exception as e:

                print(
                    f"Error comunicándose con Ollama: {e}"
                )

                await websocket.send_json({
                    "type": "error",
                    "message": "No se pudo comunicar con Ollama.",
                })

    except WebSocketDisconnect:

        print(
            "Cliente WebSocket desconectado."
        )

    except Exception as e:

        print(
            f"Error WebSocket: {e}"
        )

    finally:

        print(
            "Conexión WebSocket finalizada."
        )


# ==========================================================
# PROCESAR DATOS DE EVALUACIÓN
# ==========================================================

async def procesar_eventos_evaluacion(
    respuesta: str,
    estado: ConversationState,
    websocket: WebSocket,
):

    # ======================================================
    # EVALUATION START
    # ======================================================

    if "<EVAL_START>" in respuesta:

        if not estado.evaluacion_activa:

            estado.evaluacion_activa = True

            await websocket.send_json({
                "type": "evaluation_start"
            })

    # ======================================================
    # EVALUATION DATA
    # ======================================================

    inicio = 0

    while True:

        inicio_tag = respuesta.find(
            "<EVAL_DATA>",
            inicio
        )

        if inicio_tag == -1:
            break

        fin_tag = respuesta.find(
            "</EVAL_DATA>",
            inicio_tag
        )

        if fin_tag == -1:
            break

        contenido = respuesta[
            inicio_tag + len("<EVAL_DATA>"):
            fin_tag
        ].strip()

        try:

            dato = json.loads(contenido)

            field = dato.get("field")
            value = dato.get("value")

            if field not in estado.datos_evaluacion:

                print(
                    f"Campo desconocido: {field}"
                )

                inicio = fin_tag + len("</EVAL_DATA>")

                continue

            estado.datos_evaluacion[field] = value

            await websocket.send_json({
                "type": "evaluation_data",
                "field": field,
                "value": value,
            })

        except json.JSONDecodeError as e:

            print(
                f"Error leyendo EVAL_DATA: {e}"
            )

        inicio = fin_tag + len("</EVAL_DATA>")

    # ======================================================
    # EVALUATION COMPLETE
    # ======================================================

    if "<EVAL_COMPLETE>" in respuesta:

        estado.evaluacion_activa = False

        await websocket.send_json({
            "type": "evaluation_complete",
            "data": estado.datos_evaluacion,
        })