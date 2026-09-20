from pydantic import BaseModel


class Config(BaseModel):
    message: str
