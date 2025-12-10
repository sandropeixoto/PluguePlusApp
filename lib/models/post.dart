import 'parsers.dart';

class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });

  final int id;
  final int userId;
  final String content;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int likes;
  final int comments;
  final int shares;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      content: json['content']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      likes: parseInt(json['likes'] ?? json['likes_count'] ?? json['curtidas']),
      comments: parseInt(json['comments'] ?? json['comments_count'] ?? json['comentarios']),
      shares: parseInt(json['shares'] ?? json['shares_count'] ?? json['compartilhamentos']),
    );
  }
}
