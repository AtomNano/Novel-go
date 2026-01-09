# NOVEL-GO Postman Testing Guide

This guide contains the endpoints you can test in Postman for each microservice.

## 1. Auth Service (Node.js)
**Base URL**: `http://localhost:3001`

### Register User
- **Method**: `POST`
- **URL**: `http://localhost:3001/auth/register`
- **Body** (JSON):
  ```json
  {
    "email": "test@example.com",
    "password": "password123",
    "name": "Test User"
  }
  ```

### Login User
- **Method**: `POST`
- **URL**: `http://localhost:3001/auth/login`
- **Body** (JSON):
  ```json
  {
    "email": "test@example.com",
    "password": "password123"
  }
  ```
- **Response**: Copy the `id` from the response (e.g., `1`) for future requests.

### Get Profile
- **Method**: `GET`
- **URL**: `http://localhost:3001/users/profile?id=1`

---

## 2. Content Service (PHP/Lumen)
**Base URL**: `http://localhost:8000`

### Get All Novels
- **Method**: `GET`
- **URL**: `http://localhost:8000/novels`

### Get Novel Detail
- **Method**: `GET`
- **URL**: `http://localhost:8000/novels/1`

---

## 3. Interaction Service (Python)
**Base URL**: `http://localhost:5000`

### Add Comment
- **Method**: `POST`
- **URL**: `http://localhost:5000/comments`
- **Body** (JSON):
  ```json
  {
    "user_id": 1,
    "novel_id": 1,
    "content": "This is a great novel! Python rocks."
  }
  ```

### Get Comments for Novel
- **Method**: `GET`
- **URL**: `http://localhost:5000/comments/novel/1`

---

## 4. Collection Service (Node.js)
**Base URL**: `http://localhost:3002`

### Add to Library
- **Method**: `POST`
- **URL**: `http://localhost:3002/library`
- **Body** (JSON):
  ```json
  {
    "userId": 1,
    "novelId": 1,
    "status": "Reading"
  }
  ```

### Get User Library
- **Method**: `GET`
- **URL**: `http://localhost:3002/library/1`
