class Charger {
  const Charger({
    required this.id,
    required this.name,
    this.address,
    this.powerKw,
    this.connectorType,
    this.latitude,
    this.longitude,
    this.status = 'ativo',
    this.createdAt,
  });

  final int id;
  final String name;
  final String? address;
  final double? powerKw;
  final String? connectorType;
  final double? latitude;
  final double? longitude;
  final String status;
  final DateTime? createdAt;
}
