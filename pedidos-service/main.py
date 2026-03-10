from fastapi import FastAPI, Header, HTTPException, Request
from pydantic import BaseModel
from pymongo import MongoClient
import os
import jwt
from typing import Optional

app = FastAPI()

# Configuración
MONGO_URL = os.getenv("MONGO_URL", "mongodb://localhost:27017/ordersDB")
client = MongoClient(MONGO_URL)
db = client.ordersDB
orders_collection = db.orders

# JWT Secret (Debe coincidir con el del servicio de usuarios)
JWT_SECRET = os.getenv("JWT_SECRET", "secret")

class Order(BaseModel):
    product: str
    quantity: int
    price: float

def verify_token(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Token requerido")
    
    try:
        # Formato "Bearer <token>"
        token = authorization.split(" ")[1]
        payload = jwt.decode(token, JWT_SECRET, algorithms=["HS256"])
        return payload
    except Exception as e:
        raise HTTPException(status_code=401, detail="Token inválido")

@app.get("/")
def read_root():
    return {"message": "Orders Service is running"}

@app.post("/orders")
def create_order(order: Order, authorization: Optional[str] = Header(None)):
    user = verify_token(authorization)
    
    new_order = {
        "user_id": user["userId"],
        "username": user["username"],
        "product": order.product,
        "quantity": order.quantity,
        "price": order.price,
        "status": "pending"
    }
    
    result = orders_collection.insert_one(new_order)
    return {"message": "Orden creada", "order_id": str(result.inserted_id)}

@app.get("/orders")
def get_orders(authorization: Optional[str] = Header(None)):
    user = verify_token(authorization)
    
    # Retornar solo las órdenes del usuario
    orders = list(orders_collection.find({"user_id": user["userId"]}, {"_id": 0}))
    return orders
