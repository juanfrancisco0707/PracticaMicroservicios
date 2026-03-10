import requests
import sys

def test_direct():
    print("Testing Services Directly...")

    # 1. Register (Usuarios Service - Port 3001)
    print("\n1. Registering user (Direct -> 3001)...")
    register_url = "http://localhost:3001/register"
    user_data = {"username": "testDirect", "password": "password123"}
    try:
        response = requests.post(register_url, json=user_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
    except Exception as e:
        print(f"Error registering directly: {e}")

    # 2. Login (Usuarios Service - Port 3001)
    print("\n2. Logging in (Direct -> 3001)...")
    login_url = "http://localhost:3001/login"
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
    except Exception as e:
        print(f"Error logging in directly: {e}")

    # 3. Orders Root (Pedidos Service - Port 3002)
    print("\n3. Testing Orders Root (Direct -> 3002)...")
    try:
        response = requests.get("http://localhost:3002/")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")
    except Exception as e:
        print(f"Error accessing orders root: {e}")

if __name__ == "__main__":
    test_direct()
