class Comment {
  final int id;
  final int userId;
  final int novelId;
  final String content;
  final String? userName;
  final String? userEmail;
  final String? createdAt;
  final String? updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.novelId,
    required this.content,
    this.userName,
    this.userEmail,
    this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      novelId: json['novel_id'],
      content: json['content'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'novel_id': novelId,
      'content': content,
      'user_name': userName,
      'user_email': userEmail,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
