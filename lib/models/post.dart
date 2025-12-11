import 'parsers.dart';

class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final String content;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      content: json['content']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}
