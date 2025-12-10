import 'parsers.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    this.createdAt,
  });

  final int id;
  final String name;
  final String? icon;
  final String? description;
  final DateTime? createdAt;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: parseInt(json['id'] ?? json['categoria_id'] ?? json['codigo']),
      name:
          (json['name'] ?? json['nome'] ?? json['titulo'] ?? 'Sem nome').toString(),
      icon: json['icon']?.toString() ?? json['icone']?.toString(),
      description: json['description']?.toString() ?? json['descricao']?.toString(),
      createdAt: parseDate(json['created_at'] ?? json['data_criacao']),
    );
  }
}
