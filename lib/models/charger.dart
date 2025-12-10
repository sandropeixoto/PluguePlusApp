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

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      id: _asInt(json['id'] ?? json['charger_id'] ?? json['codigo']),
      name: (json['name'] ?? json['nome'] ?? 'Sem nome').toString(),
      address: json['address']?.toString() ?? json['endereco']?.toString(),
      powerKw: _asDouble(json['power_kw'] ?? json['potencia_kw'] ?? json['potencia']),
      connectorType:
          json['connector_type']?.toString() ?? json['tipo_conector']?.toString(),
      latitude: _asDouble(json['latitude'] ?? json['lat']),
      longitude: _asDouble(json['longitude'] ?? json['lng'] ?? json['long']),
      status: (json['status'] ?? json['situacao'] ?? 'ativo').toString(),
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
