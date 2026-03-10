import requests
import sys

BASE_URL = "http://localhost:8080"

def test_microservices():
    print("Testing Microservices...")

    # 1. Register
    print("\n1. Registering user...")
    register_url = f"{BASE_URL}/api/auth/register"
    user_data = {"username": "testuser", "password": "password123"}
    try:
        response = requests.post(register_url, json=user_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
    except Exception as e:
        print(f"Error registering: {e}")

    # 2. Login
    print("\n2. Logging in...")
    login_url = f"{BASE_URL}/api/auth/login"
    token = None
    try:
        response = requests.post(login_url, json=user_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")
        if response.status_code == 200:
            token = response.json().get("token")
            print("Token received.")
        else:
            print("Login failed.")
            return
    except Exception as e:
        print(f"Error logging in: {e}")
        return

    # 3. Create Order
    print("\n3. Creating Order...")
    orders_url = f"{BASE_URL}/api/pedidos/orders"
    order_data = {"product": "Laptop", "quantity": 1, "price": 1000.0}
    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.post(orders_url, json=order_data, headers=headers)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")
    except Exception as e:
        print(f"Error creating order: {e}")

    # 4. List Orders
    print("\n4. Listing Orders...")
    try:
        response = requests.get(orders_url, headers=headers)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")
    except Exception as e:
        print(f"Error listing orders: {e}")

if __name__ == "__main__":
    test_microservices()
