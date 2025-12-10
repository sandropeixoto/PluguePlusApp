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
    this.city,
    this.state,
    this.costType,
    this.costValue,
    this.availability,
    this.openingHours,
    this.amenities,
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
  final String? city;
  final String? state;
  final String? costType;
  final double? costValue;
  final String? availability;
  final String? openingHours;
  final String? amenities;

  factory Charger.fromJson(Map<String, dynamic> json) {
    return Charger(
      id: parseInt(json['id'] ?? json['charger_id'] ?? json['codigo']),
      name: (json['name'] ?? json['nome'] ?? 'Sem nome').toString(),
      address: json['address']?.toString() ?? json['endereco']?.toString(),
      powerKw: parseDouble(json['power_kw'] ?? json['potencia_kw'] ?? json['potencia']),
      connectorType:
          json['connector_type']?.toString() ?? json['tipo_conector']?.toString(),
      latitude: parseDouble(json['latitude'] ?? json['lat']),
      longitude: parseDouble(json['longitude'] ?? json['lng'] ?? json['long']),
      status: (json['status'] ?? json['situacao'] ?? 'ativo').toString(),
      createdAt: parseDate(json['created_at'] ?? json['data_criacao']),
      city: json['city']?.toString() ?? json['cidade']?.toString(),
      state: json['state']?.toString() ?? json['uf']?.toString(),
      costType: json['cost_type']?.toString(),
      costValue: parseDouble(json['cost_value']),
      availability: json['availability']?.toString(),
      openingHours: json['opening_hours']?.toString(),
      amenities: json['amenities']?.toString(),
    );
  }
}
import 'parsers.dart';
