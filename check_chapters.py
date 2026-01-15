import requests
import json

NOVEL_URL = "http://localhost:8080" # Localhost since I'm running on host

def check_novel():
    try:
        res = requests.get(f"{NOVEL_URL}/novels")
        if res.status_code == 200:
            novels = res.json()
            if len(novels) > 0:
                print(json.dumps(novels[0], indent=2))
            else:
                print("No novels found.")
        else:
            print(f"Failed: {res.status_code} {res.text}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_novel()
