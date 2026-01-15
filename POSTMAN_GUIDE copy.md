# API Testing Guide - Postman Collection

This guide provides comprehensive API endpoint documentation for testing the Novel-GO platform.

## 🔑 Authentication Flow

### 1. Register New User
**Endpoint**: `POST http://localhost:3001/auth/register`

**Request Body**:
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "password123",
  "address": "Jakarta, Indonesia"
}
```

**Response (201)**:
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 4,
    "email": "test@example.com",
    "name": "Test User",
    "role": "user"
  }
}
```

---

### 2. User Login
**Endpoint**: `POST http://localhost:3001/auth/login`

**Request Body**:
```json
{
  "email": "test@example.com",
  "password": "password123"
}
```

**Response (200)**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 4,
    "email": "test@example.com",
    "name": "Test User",
    "role": "user",
    "profile_photo": null,
    "address": "Jakarta, Indonesia"
  }
}
```

**Save the token** for authenticated requests!

---

## 👤 User Management (Auth Service - Port 3001)

### 3. Get User Profile
**Endpoint**: `GET http://localhost:3001/users/profile/1`

**Response (200)**:
```json
{
  "id": 1,
  "name": "Admin User",
  "email": "admin@novel.com",
  "role": "admin",
  "profile_photo": null,
  "address": "Admin Office",
  "created_at": "2026-01-10T14:30:00.000Z"
}
```

---

### 4. Update User Profile
**Endpoint**: `PUT http://localhost:3001/users/profile/1`

**Request Body** (all fields optional):
```json
{
  "name": "Updated Name",
  "email": "newemail@example.com",
  "password": "newpassword123",
  "profile_photo": "https://example.com/photo.jpg",
  "address": "New Address"
}
```

**Response (200)**:
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": 1,
    "name": "Updated Name",
    "email": "newemail@example.com",
    "role": "admin",
    "profile_photo": "https://example.com/photo.jpg",
    "address": "New Address"
  }
}
```

---

### 5. Get All Users (Admin)
**Endpoint**: `GET http://localhost:3001/users`

**Response (200)**:
```json
[
  {
    "id": 1,
    "name": "Admin User",
    "email": "admin@novel.com",
    "role": "admin",
    "profile_photo": null,
    "address": "Admin Office",
    "created_at": "2026-01-10T14:30:00.000Z"
  },
  ...
]
```

---

### 6. Get User's Favorites Count
**Endpoint**: `GET http://localhost:3001/users/1/favorites-count`

**Response (200)**:
```json
{
  "count": 3
}
```

---

### 7. Delete Account
**Endpoint**: `DELETE http://localhost:3001/users/4`

**Response (200)**:
```json
{
  "message": "Account deleted successfully"
}
```

---

## 📚 Novel Management (Content Service - Port 8000)

### 8. Get All Novels
**Endpoint**: `GET http://localhost:8000/novels`

**Response (200)**:
```json
[
  {
    "id": 1,
    "title": "The Beginning After The End",
    "author": "TurtleMe",
    "publisher": "Tapas Media",
    "cover": "https://via.placeholder.com/300x400",
    "content": "King Grey has unrivaled strength...",
    "description": "A story of reincarnation...",
    "published_date": "2016-07-04",
    "created_at": "2026-01-10T14:30:00.000Z",
    "updated_at": "2026-01-10T14:30:00.000Z",
    "view_count": 5
  },
  ...
]
```

---

### 9. Get Single Novel
**Endpoint**: `GET http://localhost:8000/novels/1`

**Response (200)**:
```json
{
  "id": 1,
  "title": "The Beginning After The End",
  "author": "TurtleMe",
  "publisher": "Tapas Media",
  "cover": "https://via.placeholder.com/300x400",
  "content": "Full novel content here...",
  "description": "A story of reincarnation...",
  "published_date": "2016-07-04",
  "created_at": "2026-01-10T14:30:00.000Z",
  "updated_at": "2026-01-10T14:30:00.000Z",
  "view_count": 5
}
```

---

### 10. Create Novel (Admin)
**Endpoint**: `POST http://localhost:8000/novels`

**Request Body**:
```json
{
  "title": "My New Novel",
  "author": "John Doe",
  "publisher": "Self Published",
  "content": "This is the full content of my novel...",
  "description": "A short description of the novel",
  "cover": "https://example.com/cover.jpg",
  "published_date": "2026-01-10"
}
```

**Response (201)**:
```json
{
  "message": "Novel created successfully",
  "novel": {
    "id": 6,
    "title": "My New Novel",
    ...
    "view_count": 0
  }
}
```

---

### 11. Update Novel (Admin)
**Endpoint**: `PUT http://localhost:8000/novels/6`

**Request Body** (all fields optional):
```json
{
  "title": "Updated Title",
  "content": "Updated content...",
  "description": "Updated description"
}
```

**Response (200)**:
```json
{
  "message": "Novel updated successfully",
  "novel": {
    "id": 6,
    "title": "Updated Title",
    ...
  }
}
```

---

### 12. Delete Novel (Admin)
**Endpoint**: `DELETE http://localhost:8000/novels/6`

**Response (200)**:
```json
{
  "message": "Novel deleted successfully"
}
```

---

### 13. Track Novel View
**Endpoint**: `POST http://localhost:8000/novels/1/view`

**Request Body**:
```json
{
  "user_id": 1
}
```

**Response (200)**:
```json
{
  "message": "View recorded",
  "view_count": 6
}
```

---

## 💬 Comment Management (Interaction Service - Port 5000)

### 14. Get Comments for a Novel
**Endpoint**: `GET http://localhost:5000/comments/novel/1`

**Response (200)**:
```json
[
  {
    "id": 1,
    "user_id": 2,
    "novel_id": 1,
    "content": "Amazing story! The world-building is incredible.",
    "created_at": "2026-01-10 14:30:00",
    "updated_at": "2026-01-10 14:30:00",
    "user_name": "John Doe",
    "user_email": "john@example.com"
  },
  ...
]
```

---

### 15. Get All Comments (Admin)
**Endpoint**: `GET http://localhost:5000/comments`

**Response (200)**:
```json
[
  {
    "id": 1,
    "user_id": 2,
    "novel_id": 1,
    "content": "Amazing story!",
    "created_at": "2026-01-10 14:30:00",
    "updated_at": "2026-01-10 14:30:00",
    "user_name": "John Doe",
    "user_email": "john@example.com",
    "novel_title": "The Beginning After The End"
  },
  ...
]
```

---

### 16. Create Comment
**Endpoint**: `POST http://localhost:5000/comments`

**Request Body**:
```json
{
  "user_id": 1,
  "novel_id": 1,
  "content": "This is an excellent novel! Highly recommended."
}
```

**Response (201)**:
```json
{
  "id": 6,
  "user_id": 1,
  "novel_id": 1,
  "content": "This is an excellent novel! Highly recommended.",
  "created_at": "2026-01-10 15:00:00",
  "updated_at": "2026-01-10 15:00:00",
  "user_name": "Admin User",
  "user_email": "admin@novel.com"
}
```

---

### 17. Update Comment
**Endpoint**: `PUT http://localhost:5000/comments/6`

**Request Body**:
```json
{
  "content": "Updated comment text here"
}
```

**Response (200)**:
```json
{
  "id": 6,
  "user_id": 1,
  "novel_id": 1,
  "content": "Updated comment text here",
  "created_at": "2026-01-10 15:00:00",
  "updated_at": "2026-01-10 15:05:00",
  "user_name": "Admin User",
  "user_email": "admin@novel.com"
}
```

---

### 18. Delete Comment
**Endpoint**: `DELETE http://localhost:5000/comments/6`

**Response (200)**:
```json
{
  "message": "Comment deleted successfully"
}
```

---

## ⭐ Favorites Management (Collection Service - Port 3002)

### 19. Get User's Favorites
**Endpoint**: `GET http://localhost:3002/favorites/1`

**Response (200)**:
```json
[
  {
    "id": 1,
    "novel_id": 1,
    "created_at": "2026-01-10T14:30:00.000Z",
    "title": "The Beginning After The End",
    "author": "TurtleMe",
    "publisher": "Tapas Media",
    "cover": "https://via.placeholder.com/300x400",
    "description": "A story of reincarnation...",
    "view_count": 5
  },
  ...
]
```

---

### 20. Add to Favorites
**Endpoint**: `POST http://localhost:3002/favorites`

**Request Body**:
```json
{
  "userId": 1,
  "novelId": 2
}
```

**Response (201)**:
```json
{
  "message": "Added to favorites",
  "favorite": {
    "id": 7,
    "novel_id": 2,
    "created_at": "2026-01-10T15:00:00.000Z",
    "title": "Solo Leveling",
    "author": "Chugong",
    "publisher": "D&C Media",
    "cover": "https://via.placeholder.com/300x400",
    "description": "From the weakest hunter..."
  }
}
```

---

### 21. Remove from Favorites
**Endpoint**: `DELETE http://localhost:3002/favorites/7`

**Response (200)**:
```json
{
  "message": "Removed from favorites"
}
```

---

### 22. Remove by User and Novel ID
**Endpoint**: `DELETE http://localhost:3002/favorites/user/1/novel/2`

**Response (200)**:
```json
{
  "message": "Removed from favorites"
}
```

---

### 23. Get Users Who Favorited a Novel (Admin)
**Endpoint**: `GET http://localhost:3002/favorites/novel/1/users`

**Response (200)**:
```json
[
  {
    "id": 2,
    "name": "John Doe",
    "email": "john@example.com",
    "favorited_at": "2026-01-10T14:30:00.000Z"
  },
  ...
]
```

---

## 🧪 Testing Workflow

### Complete User Journey

1. **Register** → Save user ID
2. **Login** → Save JWT token
3. **Browse Novels** → Get novel list
4. **View Novel** → Track view count
5. **Add Comment** → Post a comment
6. **Add to Favorites** → Save novel
7. **View Favorites** → See saved novels
8. **Update Profile** → Change user info
9. **Remove Favorite** → Unsave novel
10. **Delete Comment** → Remove comment

### Admin Tasks

1. **Create Novel** → Add new content
2. **Update Novel** → Edit existing
3. **Delete Novel** → Remove content
4. **View All Users** → User management
5. **View All Comments** → Moderation
6. **Delete Any Comment** → Admin control

---

## 📝 Notes

- All timestamps are in UTC
- User IDs start from 1 (auto-increment)
- Novel IDs start from 1 (auto-increment)
- JWT tokens expire after 24 hours
- Passwords are hashed with bcrypt (10 rounds)
- Foreign key constraints ensure data integrity

---

## 🔒 Security

- Always hash passwords before storing
- Use JWT tokens for authenticated requests
- Validate user ownership for updates/deletes
- Sanitize all user inputs
- Use HTTPS in production
