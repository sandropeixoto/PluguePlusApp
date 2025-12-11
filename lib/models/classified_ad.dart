import 'parsers.dart';

class ClassifiedAd {
  const ClassifiedAd({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    this.status,
    this.views,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.images = const [],
    this.categoryName,
  });

  final int id;
  final int userId;
  final int categoryId;
  final String title;
  final String description;
  final double price;
  final String? status;
  final int? views;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> images;
  final String? categoryName;

  factory ClassifiedAd.fromJson(Map<String, dynamic> json) {
    final images = <String>[];
    if (json['images'] is List) {
      for (final item in (json['images'] as List)) {
        if (item is Map<String, dynamic>) {
          final path = item['image_path']?.toString();
          if (path != null) images.add(path);
        } else if (item != null) {
          images.add(item.toString());
        }
      }
    }
    return ClassifiedAd(
      id: parseInt(json['id']),
      userId: parseInt(json['user_id']),
      categoryId: parseInt(json['category_id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: parseDouble(json['price']) ?? 0,
      status: json['status']?.toString(),
      views: parseInt(json['views'], fallback: 0),
      expiresAt: parseDate(json['expires_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      images: images,
      categoryName: json['category_name']?.toString(),
    );
  }
}
