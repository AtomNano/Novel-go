import requests
import time
import sys

def test_service(name, url, file_obj):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            log(f"[PASS] {name} is running at {url}", file_obj)
            return True
        else:
            log(f"[FAIL] {name} returned status {response.status_code}", file_obj)
            return False
    except Exception as e:
        log(f"[FAIL] {name} could not be reached: {e}", file_obj)
        return False

def log(message, file_obj):
    print(message)
    file_obj.write(message + "\n")

def run_tests():
    with open("test_results.log", "w") as f:
        log("Starting Automated Tests for NOVEL-GO Microservices...\n", f)
        
        # 1. Auth Service Tests
        log("--- Testing Auth Service ---", f)
        auth_url = "http://localhost:3001"
        if test_service("Auth Service Health", auth_url, f):
            # Register an automated test user
            user_email = f"auto_test_{int(time.time())}@example.com"
            register_payload = {
                "name": "Auto Tester",
                "email": user_email,
                "password": "password123"
            }
            try:
                reg_res = requests.post(f"{auth_url}/auth/register", json=register_payload)
                if reg_res.status_code == 201:
                    log(f"[PASS] Registration successful for {user_email}", f)
                    user_id = reg_res.json()['user']['id']
                    
                    # Login
                    login_payload = {"email": user_email, "password": "password123"}
                    login_res = requests.post(f"{auth_url}/auth/login", json=login_payload)
                    if login_res.status_code == 200 and 'token' in login_res.json():
                        log("[PASS] Login successful, token received", f)
                    else:
                        log(f"[FAIL] Login failed: {login_res.text}", f)
                else:
                    log(f"[FAIL] Registration failed: {reg_res.text}", f)
            except Exception as e:
                log(f"[FAIL] Auth flow error: {e}", f)

        # 2. Content Service Tests
        log("\n--- Testing Content Service ---", f)
        content_url = "http://localhost:8000"
        if test_service("Content Service Health", content_url, f):
            try:
                novels_res = requests.get(f"{content_url}/novels")
                if novels_res.status_code == 200 and isinstance(novels_res.json(), list):
                    log(f"[PASS] Retrieved {len(novels_res.json())} novels", f)
                else:
                    log(f"[FAIL] Get Novels failed", f)
            except Exception as e:
               log(f"[FAIL] Content flow error: {e}", f)

        # 3. Interaction Service Tests
        log("\n--- Testing Interaction Service ---", f)
        interaction_url = "http://localhost:5000"
        if test_service("Interaction Service Health", interaction_url, f):
            try:
                # Post comment
                comment_payload = {
                    "user_id": 999,
                    "novel_id": 1,
                    "content": "Automated test comment"
                }
                post_res = requests.post(f"{interaction_url}/comments", json=comment_payload)
                if post_res.status_code == 201:
                    log("[PASS] Posted comment successfully", f)
                    
                    # Get comments
                    get_res = requests.get(f"{interaction_url}/comments/novel/1")
                    if get_res.status_code == 200:
                        comments = get_res.json()
                        if any(c['content'] == "Automated test comment" for c in comments):
                            log("[PASS] Verified comment exists in list", f)
                        else:
                            log("[FAIL] Comment not found in list", f)
                else:
                    log(f"[FAIL] Post comment failed: {post_res.text}", f)
            except Exception as e:
                log(f"[FAIL] Interaction flow error: {e}", f)

        # 4. Collection Service Tests
        log("\n--- Testing Collection Service ---", f)
        collection_url = "http://localhost:3002"
        if test_service("Collection Service Health", collection_url, f):
            try:
                # Add to library
                lib_payload = {
                    "userId": 999,
                    "novelId": 2,
                    "status": "Reading"
                }
                requests.post(f"{collection_url}/library", json=lib_payload)
                
                # Get library
                get_lib = requests.get(f"{collection_url}/library/999")
                if get_lib.status_code == 200:
                    log(f"[PASS] Retrieved library, items: {len(get_lib.json())}", f)
                else:
                     log(f"[FAIL] Get library failed", f)
            except Exception as e:
                log(f"[FAIL] Collection flow error: {e}", f)

if __name__ == "__main__":
    run_tests()
