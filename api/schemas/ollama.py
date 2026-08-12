from pydantic import BaseModel


class PromptRequest(BaseModel):
    prompt: str
    stream: bool = False


class OllamaResponse(BaseModel):
    result: str

