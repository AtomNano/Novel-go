class Novel {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final String cover;
  final String? content;
  final String? description;
  final int viewCount;
  final String? publishedDate;
  final String? createdAt;

  Novel({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.cover,
    this.content,
    this.description,
    this.viewCount = 0,
    this.publishedDate,
    this.createdAt,
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      cover: json['cover'] ?? 'https://via.placeholder.com/300x400',
      content: json['content'],
      description: json['description'],
      viewCount: json['view_count'] ?? 0,
      publishedDate: json['published_date'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'cover': cover,
      'content': content,
      'description': description,
      'view_count': viewCount,
      'published_date': publishedDate,
      'created_at': createdAt,
    };
  }
}
