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
    required this.categoryName,
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
  final String categoryName;
  final DateTime? createdAt;
}
