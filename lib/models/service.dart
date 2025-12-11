import 'parsers.dart';

class Service {
  const Service({
    required this.id,
    required this.name,
    this.description,
    this.phone,
    this.site,
    this.latitude,
    this.longitude,
    required this.categoryId,
    this.categoryName,
    this.createdAt,
    this.city,
    this.state,
    this.status,
    this.address,
    this.email,
    this.website,
  });

  final int id;
  final String name;
  final String? description;
  final String? phone;
  final String? site;
  final double? latitude;
  final double? longitude;
  final int categoryId;
  final String? categoryName;
  final DateTime? createdAt;
  final String? city;
  final String? state;
  final String? status;
  final String? address;
  final String? email;
  final String? website;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: parseInt(json['id'] ?? json['service_id'] ?? json['codigo']),
      name: (json['name'] ?? json['nome'] ?? 'Sem nome').toString(),
      description:
          json['description']?.toString() ?? json['descricao']?.toString(),
      phone: json['phone']?.toString() ?? json['telefone']?.toString(),
      site:
          json['site']?.toString() ??
          json['url']?.toString() ??
          json['link']?.toString(),
      address: json['address']?.toString() ?? json['endereco']?.toString(),
      latitude: parseDouble(json['latitude'] ?? json['lat']),
      longitude: parseDouble(json['longitude'] ?? json['lng'] ?? json['long']),
      categoryId: parseInt(
        json['category_id'] ?? json['categoria_id'] ?? json['category'],
      ),
      categoryName:
          json['category_name']?.toString() ??
          json['categoria_nome']?.toString(),
      createdAt: parseDate(json['created_at'] ?? json['data_criacao']),
      city: json['city']?.toString() ?? json['cidade']?.toString(),
      state: json['state']?.toString() ?? json['uf']?.toString(),
      status: json['status']?.toString(),
      email: json['email']?.toString(),
      website: json['website']?.toString(),
    );
  }
}
