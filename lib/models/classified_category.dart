import 'parsers.dart';

class ClassifiedCategory {
  const ClassifiedCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
  });

  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;

  factory ClassifiedCategory.fromJson(Map<String, dynamic> json) {
    return ClassifiedCategory(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
    );
  }
}
