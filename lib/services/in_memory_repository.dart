import 'package:collection/collection.dart';

import '../models/category.dart';
import '../models/charger.dart';
import '../models/service.dart';

/// Reimplementa a mesma logica do backend PHP em uma camada local de memoria.
class InMemoryRepository {
  InMemoryRepository() {
    _seed();
  }

  final List<Category> _categories = [];
  final List<Service> _services = [];
  final List<Charger> _chargers = [];

  List<Category> listCategories() => List.unmodifiable(_categories);

  List<Service> listServices() => List.unmodifiable(_services);

  List<Charger> listChargers() => List.unmodifiable(_chargers);

  Category createCategory({required String name, String? icon}) {
    final nextId = _categories.isEmpty ? 1 : _categories.last.id + 1;
    final category = Category(id: nextId, name: name, icon: icon);
    _categories.add(category);
    return category;
  }

  Service createService({
    required String name,
    required int categoryId,
    String? description,
    String? phone,
    String? site,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    final category = _categories.firstWhereOrNull((c) => c.id == categoryId);
    if (category == null) {
      throw ArgumentError('Categoria inexistente');
    }
    final nextId = _services.isEmpty ? 1 : _services.last.id + 1;
    final service = Service(
      id: nextId,
      name: name,
      description: description,
      phone: phone,
      site: site,
      address: address,
      latitude: latitude,
      longitude: longitude,
      categoryId: categoryId,
      categoryName: category.name,
      createdAt: DateTime.now(),
    );
    _services.add(service);
    return service;
  }

  Charger createCharger({
    required String name,
    String? address,
    double? powerKw,
    String? connectorType,
    double? latitude,
    double? longitude,
    String status = 'ativo',
  }) {
    final nextId = _chargers.isEmpty ? 1 : _chargers.last.id + 1;
    final charger = Charger(
      id: nextId,
      name: name,
      address: address,
      powerKw: powerKw,
      connectorType: connectorType,
      latitude: latitude,
      longitude: longitude,
      status: status,
      createdAt: DateTime.now(),
    );
    _chargers.add(charger);
    return charger;
  }

  void _seed() {
    final catEletrica = createCategory(name: 'Eletrica', icon: 'bolt');
    final catOficinas = createCategory(name: 'Oficinas', icon: 'build');
    final catHospedagem = createCategory(name: 'Hospedagem', icon: 'hotel');

    createService(
      name: 'Eletroposto Centro',
      categoryId: catEletrica.id,
      description: 'Ponto com vagas cobertas e atendimento 24h.',
      phone: '(11) 99999-8888',
      site: 'https://plugueplus.example/eletroposto',
      address: 'Av. Principal, 123',
      latitude: -23.55,
      longitude: -46.64,
    );
    createService(
      name: 'Oficina Rápida EV',
      categoryId: catOficinas.id,
      description: 'Manutencao preventiva e pneus.',
      phone: '(11) 98888-0000',
      address: 'Rua das Oficinas, 45',
    );
    createService(
      name: 'Hotel Verde Luz',
      categoryId: catHospedagem.id,
      description: 'Estadia com vaga para carregamento lento.',
      site: 'https://hotelverdeluz.example',
    );

    createCharger(
      name: 'Plugue+ Shopping',
      address: 'Estacionamento subsolo B2',
      powerKw: 22,
      connectorType: 'Type 2',
      status: 'ativo',
    );
    createCharger(
      name: 'Posto Norte',
      address: 'Rodovia BR-050 km 12',
      connectorType: 'CCS',
      powerKw: 50,
      status: 'manutencao',
    );
  }
}
