from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import yaml

with open("config.yaml","r") as archivo:
    config = yaml.safe_load(archivo)

DATABASE_URL = config["database"]["url"]

engine = create_engine(
    DATABASE_URL
)


SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)


Base = declarative_base()


def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()