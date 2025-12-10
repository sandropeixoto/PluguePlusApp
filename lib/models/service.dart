class Service {
  const Service({
    required this.id,
    required this.name,
    this.description,
    this.phone,
    this.site,
    this.address,
    this.latitude,
    this.longitude,
    required this.categoryId,
    this.categoryName,
    this.createdAt,
  });

  final int id;
  final String name;
  final String? description;
  final String? phone;
  final String? site;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int categoryId;
  final String? categoryName;
  final DateTime? createdAt;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: _asInt(json['id'] ?? json['service_id'] ?? json['codigo']),
      name: (json['name'] ?? json['nome'] ?? 'Sem nome').toString(),
      description: json['description']?.toString() ?? json['descricao']?.toString(),
      phone: json['phone']?.toString() ?? json['telefone']?.toString(),
      site: json['site']?.toString() ??
          json['url']?.toString() ??
          json['link']?.toString(),
      address: json['address']?.toString() ?? json['endereco']?.toString(),
      latitude: _asDouble(json['latitude'] ?? json['lat']),
      longitude: _asDouble(json['longitude'] ?? json['lng'] ?? json['long']),
      categoryId:
          _asInt(json['category_id'] ?? json['categoria_id'] ?? json['category']),
      categoryName: json['category_name']?.toString() ??
          json['categoria_nome']?.toString(),
      createdAt: _asDate(json['created_at'] ?? json['data_criacao']),
    );
  }
}

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
