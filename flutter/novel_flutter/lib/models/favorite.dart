import '../models/novel.dart';

class Favorite {
  final int id;
  final int novelId;
  final String? createdAt;
  final Novel? novel;

  Favorite({
    required this.id,
    required this.novelId,
    this.createdAt,
    this.novel,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      novelId: json['novel_id'],
      createdAt: json['created_at'],
      novel: json['title'] != null ? Novel.fromJson(json) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'novel_id': novelId,
      'created_at': createdAt,
    };
  }
}
