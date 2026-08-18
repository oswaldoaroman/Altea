import yaml

with open("config.yaml", "r") as archivo:
    config = yaml.safe_load(archivo)

OLLAMA_API_URL = config["ollama"]["api_url"]
MODEL_NAME = config["ollama"]["model_name"]

print(OLLAMA_API_URL)
print(MODEL_NAME)
