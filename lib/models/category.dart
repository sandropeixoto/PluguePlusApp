class Category {
  const Category({
    required this.id,
    required this.name,
    this.icon,
  });

  final int id;
  final String name;
  final String? icon;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: _asInt(json['id'] ?? json['categoria_id'] ?? json['codigo']),
      name: (json['name'] ?? json['nome'] ?? json['titulo'] ?? 'Sem nome')
          .toString(),
      icon: json['icon']?.toString() ?? json['icone']?.toString(),
    );
  }
}

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}
