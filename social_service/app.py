from flask import Flask, request, jsonify
from flask_cors import CORS
from data import comments

app = Flask(__name__)
CORS(app)

# =====================
# ROOT ENDPOINT
# =====================
@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "service": "Social & Feedback Service",
        "status": "running",
        "endpoints": {
            "GET /comments": "List all comments (optional: ?chapter_id=<id>)",
            "GET /comments/<id>": "Get a specific comment by ID",
            "POST /comments": "Create a new comment",
            "PUT /comments/<id>": "Update a comment",
            "DELETE /comments/<id>": "Delete a comment"
        }
    })

# =====================
# READ - List Komentar
# =====================
@app.route("/comments", methods=["GET"])
def get_comments():
    chapter_id = request.args.get("chapter_id", type=int)
    novel_id = request.args.get("novel_id", type=int)
    
    filtered_comments = comments
    
    if chapter_id:
        filtered_comments = [c for c in filtered_comments if c["chapter_id"] == chapter_id]
    
    if novel_id:
        filtered_comments = [c for c in filtered_comments if c["novel_id"] == novel_id]
        
    return jsonify(filtered_comments)

# =====================
# READ - Get Single Comment
# =====================
@app.route("/comments/<int:id>", methods=["GET"])
def get_comment(id):
    for c in comments:
        if c["id"] == id:
            return jsonify(c)
    return jsonify({"message": "Komentar tidak ditemukan"}), 404

# =====================
# CREATE - Tambah Komentar
# =====================
@app.route("/comments", methods=["POST"])
def add_comment():
    # Support both JSON and form-data
    if request.is_json:
        data = request.json
    else:
        data = request.form
    
    new_comment = {
        "id": len(comments) + 1,
        "user_id": int(data.get("user_id")),
        "novel_id": int(data.get("novel_id")),
        "chapter_id": int(data.get("chapter_id", 0)), # Default to 0 if not provided
        "content": data.get("content")
    }
    comments.append(new_comment)
    return jsonify(new_comment), 201

# =====================
# UPDATE - Edit Komentar
# =====================
@app.route("/comments/<int:id>", methods=["PUT"])
def update_comment(id):
    # Support both JSON and form-data
    if request.is_json:
        data = request.json
    else:
        data = request.form
    
    for c in comments:
        if c["id"] == id:
            c["content"] = data["content"]
            return jsonify(c)
    return jsonify({"message": "Komentar tidak ditemukan"}), 404

# =====================
# DELETE - Hapus Komentar
# =====================
@app.route("/comments/<int:id>", methods=["DELETE"])
def delete_comment(id):
    for c in comments:
        if c["id"] == id:
            comments.remove(c)
            return jsonify({"message": "Komentar dihapus"})
    return jsonify({"message": "Komentar tidak ditemukan"}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=True)
