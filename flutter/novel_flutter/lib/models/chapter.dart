class Chapter {
  final int id;
  final int novelId;
  final String title;
  final String content;
  final int chapterNumber;
  final String? createdAt;

  Chapter({
    required this.id,
    required this.novelId,
    required this.title,
    required this.content,
    required this.chapterNumber,
    this.createdAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      novelId: json['novel_id'],
      title: json['title'],
      content: json['content'],
      chapterNumber: json['chapter_number'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'novel_id': novelId,
      'title': title,
      'content': content,
      'chapter_number': chapterNumber,
      'created_at': createdAt,
    };
  }
}
