import requests
import json
import sys

# Configuration
AUTH_URL = "http://localhost:3001"
NOVEL_URL = "http://localhost:8080"
SOCIAL_URL = "http://localhost:5003"
COLLECTION_URL = "http://localhost:3002"

def print_header(title):
    print(f"\n{'='*50}")
    print(f" TESTING: {title}")
    print(f"{'='*50}")

def test_auth():
    print_header("Auth Service")
    
    # 0. Test Register
    print("\n0. Testing Registration (testuser_unique@example.com)...")
    try:
        import time
        email = f"testuser_{int(time.time())}@example.com"
        payload = {
            "name": "Test User",
            "email": email,
            "password": "password",
            "address": "123 Test St"
        }
        res = requests.post(f"{AUTH_URL}/auth/register", json=payload)
        print(f"Status: {res.status_code}")
        if res.status_code == 201:
            print("Registration SUCCESS!")
            # 1a. Test Login with NEW USER
            print(f"1a. Testing Login with New User ({email})...")
            login_payload = {"email": email, "password": "password"}
            login_res = requests.post(f"{AUTH_URL}/auth/login", json=login_payload)
            if login_res.status_code == 200:
                 print("Login (New User) SUCCESS!")
            else:
                 print(f"Login (New User) FAILED: {login_res.text}")
        else:
            print(f"Registration FAILED: {res.text}")
    except Exception as e:
        print(f"ERROR: {e}")

    # 1. Test Login (admin@novel.com)
    print("\n1. Testing Login (admin@novel.com)...")
    try:
        payload = {"email": "admin@novel.com", "password": "password"}
        res = requests.post(f"{AUTH_URL}/auth/login", json=payload)
        print(f"Status: {res.status_code}")
        if res.status_code == 200:
            print("Login SUCCESS!")
            print(f"User: {res.json().get('user', {}).get('name')}")
            return res.json().get('token')
        else:
            print(f"Login FAILED: {res.text}")
            return None
    except Exception as e:
        print(f"ERROR: {e}")
        return None

def test_novel_core(token=None):
    print_header("Novel Core Service")
    
    # 0. Create Novel (Full Metadata) if token provided
    if token:
        print("\n0. Creating Novel with Full Metadata...")
        try:
            payload = {
                "title": "Solo Leveling",
                "author": "Chugong",
                "publisher": "D&C Media",
                "cover": "https://example.com/cover.jpg",
                "description": "Weakest hunter becomes strongest.",
                "content": "This is the full content of the novel. It should be saved now.",
                "published_date": "2018-03-04"
            }
            res = requests.post(
                f"{NOVEL_URL}/novels", 
                json=payload,
                headers={"Authorization": f"Bearer {token}"}
            )
            print(f"Status: {res.status_code}")
            if res.status_code == 201:
                data = res.json()
                print("Novel Created SUCCESS!")
                print(f"Saved Content Length: {len(data.get('content') or '')}")
                novel_id = data.get('id')
                
                # 0a. Test Update Novel
                print("0a. Updating Novel...")
                update_payload = {"title": "Solo Leveling (Updated)"}
                upd_res = requests.put(
                    f"{NOVEL_URL}/novels/{novel_id}",
                    json=update_payload,
                    headers={"Authorization": f"Bearer {token}"}
                )
                print(f"Update Status: {upd_res.status_code}")
                if upd_res.status_code == 200:
                    print("Novel Update SUCCESS!")
                else:
                    print(f"Novel Update FAILED: {upd_res.text}")

                # We will delete it at the end or keep it for other tests? 
                # Let's keep it for other tests, but maybe test delete separately or returned ID.
                return novel_id
            else:
                print(f"Novel Creation FAILED: {res.text}")
        except Exception as e:
            print(e)

    # 1. Test Get All Novels
    print("\n1. Fetching All Novels...")
    try:
        res = requests.get(f"{NOVEL_URL}/novels")
        print(f"Status: {res.status_code}")
        if res.status_code == 200:
            novels = res.json()
            print(f"Found {len(novels)} novels.")
            if len(novels) > 0:
                print(f"Sample: {novels[0].get('title')}")
                return novels[0].get('id')
            else:
                return 1
        else:
            print(f"FAILED: {res.text}")
            return 1
    except Exception as e:
        print(f"ERROR: {e}")
        return 1

def test_social(novel_id):
    print_header("Social Service")
    
    # 1. Test Create Comment (No Chapter ID)
    print("\n1. Creating Comment for Novel ID {}...".format(novel_id))
    try:
        payload = {
            "user_id": 1,
            "novel_id": novel_id,
            "content": "This is a test comment from verification script."
        }
        res = requests.post(f"{SOCIAL_URL}/comments", json=payload)
        print(f"Status: {res.status_code}")
        if res.status_code == 201:
            print("Comment Created SUCCESS!")
        else:
            print(f"Comment Creation FAILED: {res.text}")
    except Exception as e:
        print(f"ERROR: {e}")

    # 2. Test Get Comments by Novel ID
    print(f"\n2. Fetching Comments for Novel ID {novel_id}...")
    try:
        res = requests.get(f"{SOCIAL_URL}/comments", params={"novel_id": novel_id})
        print(f"Status: {res.status_code}")
        if res.status_code == 200:
            comments = res.json()
            print(f"Found {len(comments)} comments.")
        else:
            print(f"FAILED: {res.text}")
    except Exception as e:
        print(f"ERROR: {e}")

def test_collection(user_id, novel_id):
    print_header("Collection Service")
    
    # 1. Add to Favorites
    print(f"\n1. Adding Novel ID {novel_id} to Favorites for User {user_id}...")
    try:
        payload = {"userId": user_id, "novelId": novel_id}
        res = requests.post(f"{COLLECTION_URL}/favorites", json=payload)
        print(f"Status: {res.status_code}")
        if res.status_code == 201:
            print("Added to Favorites SUCCESS!")
            fav_id = res.json().get('favorite', {}).get('id')
        elif res.status_code == 400 and "already in favorites" in res.text:
            print("Already in Favorites.")
            fav_id = None # Skip delete if not added just now
        else:
            print(f"FAILED: {res.text}")
            fav_id = None
    except Exception as e:
        print(f"ERROR: {e}")
        fav_id = None
        
    # 2. Get User Favorites
    print(f"\n2. Fetching Favorites for User {user_id}...")
    try:
        res = requests.get(f"{COLLECTION_URL}/favorites/{user_id}")
        print(f"Status: {res.status_code}")
        if res.status_code == 200:
            favs = res.json()
            print(f"Found {len(favs)} favorites.")
        else:
            print(f"FAILED: {res.text}")
    except Exception as e:
        print(f"ERROR: {e}")

    # 3. Remove (Cleanup)
    if fav_id:
        print(f"\n3. Removing Favorite ID {fav_id}...")
        requests.delete(f"{COLLECTION_URL}/favorites/{fav_id}")

def main():
    print("STARTING SYSTEM CHECK...")
    
    user_id = 1 # Admin ID
    
    token = test_auth() # Creates user and tests login
    # Ideally navigate to get the dynamic user ID if implementing full flow
    
    if token:
         novel_id = test_novel_core(token)
    else:
         print("Skipping Novel Creation due to Auth failure.")
         novel_id = 1 # Fallback to existing ID if any
    
    if novel_id:
        test_social(novel_id)
        test_collection(user_id, novel_id)
        
        # Test Delete Novel (Cleanup)
        if token:
            print("\n3. Deleting Novel ID {}...".format(novel_id))
            del_res = requests.delete(
                f"{NOVEL_URL}/novels/{novel_id}",
                headers={"Authorization": f"Bearer {token}"}
            )
            print(f"Delete Status: {del_res.status_code}")
            if del_res.status_code == 200:
                print("Novel Delete SUCCESS!")
            else:
                print(f"Novel Delete FAILED: {del_res.text}")
        
    print("\nSystem Check Complete.")

if __name__ == "__main__":
    main()
