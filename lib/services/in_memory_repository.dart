import 'package:collection/collection.dart';

import '../models/category.dart';
import '../models/charger.dart';
import '../models/post.dart';
import '../models/service.dart';
import '../models/user.dart';
import 'repository.dart';

/// Reimplementa a mesma logica do backend PHP em uma camada local de memoria.
class InMemoryRepository implements Repository {
  InMemoryRepository() {
    _seed();
  }

  final List<Category> _categories = [];
  final List<Service> _services = [];
  final List<Charger> _chargers = [];
  final List<User> _users = [];
  final List<Post> _posts = [];

  List<Category> listCategories() => List.unmodifiable(_categories);
  List<Service> listServices() => List.unmodifiable(_services);
  List<Charger> listChargers() => List.unmodifiable(_chargers);
  List<User> listUsers() => List.unmodifiable(_users);
  List<Post> listPosts() => List.unmodifiable(_posts);

  @override
  Future<List<Category>> fetchCategories() async => listCategories();

  @override
  Future<List<Service>> fetchServices() async => listServices();

  @override
  Future<List<Charger>> fetchChargers() async => listChargers();

  @override
  Future<RepositorySnapshot> fetchSnapshot() async {
    return RepositorySnapshot(
      categories: listCategories(),
      services: listServices(),
      chargers: listChargers(),
    );
  }

  @override
  Future<List<Post>> fetchPosts() async => listPosts();

  @override
  Future<List<User>> fetchUsers() async => listUsers();

  Category createCategory({required String name, String? icon}) {
    final nextId = _categories.isEmpty ? 1 : _categories.last.id + 1;
    final category = Category(
      id: nextId,
      name: name,
      icon: icon,
      description: 'Servicos de $name para mobilidade eletrica.',
      createdAt: DateTime.now(),
    );
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
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    String? status,
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
      city: city,
      state: state,
      latitude: latitude,
      longitude: longitude,
      categoryId: categoryId,
      categoryName: category.name,
      createdAt: DateTime.now(),
      status: status,
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
    String? city,
    String? state,
    String? costType,
    double? costValue,
    String? availability,
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
      city: city,
      state: state,
      costType: costType,
      costValue: costValue,
      availability: availability,
    );
    _chargers.add(charger);
    return charger;
  }

  User createUser({
    required String name,
    required String email,
    String? city,
    String? state,
  }) {
    final nextId = _users.isEmpty ? 1 : _users.last.id + 1;
    final user = User(
      id: nextId,
      name: name,
      email: email,
      city: city,
      state: state,
      createdAt: DateTime.now(),
    );
    _users.add(user);
    return user;
  }

  Post createPost({
    required int userId,
    required String content,
    int likes = 0,
    int comments = 0,
    int shares = 0,
  }) {
    final nextId = _posts.isEmpty ? 1 : _posts.last.id + 1;
    final post = Post(
      id: nextId,
      userId: userId,
      content: content,
      createdAt: DateTime.now(),
      likes: likes,
      comments: comments,
      shares: shares,
    );
    _posts.add(post);
    return post;
  }

  void _seed() {
    final userSandro = createUser(
      name: 'Sandro Peixoto',
      email: 'sandro@plugueplus.com',
      city: 'Belem',
      state: 'PA',
    );
    final userGabi = createUser(
      name: 'Gabriela Santos',
      email: 'gabi@plugueplus.com',
      city: 'Belem',
      state: 'PA',
    );

    final catEletrica = createCategory(name: 'Eletrica Automotiva', icon: 'bolt');
    final catOficinas = createCategory(name: 'Oficina Mecanica', icon: 'build');
    final catHospedagem = createCategory(name: 'Hospitalidade', icon: 'hotel');
    final catAcessorios = createCategory(name: 'Acessorios', icon: 'shopping');

    createService(
      name: 'Eletroposto Centro',
      categoryId: catEletrica.id,
      description: 'Ponto com vagas cobertas e atendimento 24h.',
      phone: '(11) 99999-8888',
      site: 'https://plugueplus.example/eletroposto',
      address: 'Av. Principal, 123',
      city: 'Sao Paulo',
      state: 'SP',
      latitude: -23.55,
      longitude: -46.64,
      status: 'active',
    );
    createService(
      name: 'Oficina Rapida EV',
      categoryId: catOficinas.id,
      description: 'Manutencao preventiva e pneus.',
      phone: '(11) 98888-0000',
      address: 'Rua das Oficinas, 45',
      city: 'Belem',
      state: 'PA',
      status: 'active',
    );
    createService(
      name: 'Hotel Verde Luz',
      categoryId: catHospedagem.id,
      description: 'Estadia com vaga para carregamento lento.',
      site: 'https://hotelverdeluz.example',
      address: 'Av. dos Lagos, 500',
      city: 'Curitiba',
      state: 'PR',
      status: 'active',
    );
    createService(
      name: 'Eco Accessories',
      categoryId: catAcessorios.id,
      description: 'Cabos, adaptadores e tapetes eco-friendly.',
      site: 'https://ecoaccessories.example',
      city: 'Porto Alegre',
      state: 'RS',
      status: 'active',
    );

    createCharger(
      name: 'Plugue+ Shopping',
      address: 'Estacionamento subsolo B2',
      powerKw: 22,
      connectorType: 'Type 2',
      status: 'ativo',
      city: 'Sao Paulo',
      state: 'SP',
      costType: 'pago',
      costValue: 25.0,
      availability: 'available',
    );
    createCharger(
      name: 'Posto Norte',
      address: 'Rodovia BR-050 km 12',
      connectorType: 'CCS',
      powerKw: 50,
      status: 'manutencao',
      city: 'Goiania',
      state: 'GO',
      availability: 'maintenance',
      costType: 'gratuito',
    );

    createPost(
      userId: userSandro.id,
      content: 'Instalei um carregador residencial ontem, foi rapido e seguro.',
      likes: 12,
      comments: 3,
      shares: 1,
    );
    createPost(
      userId: userGabi.id,
      content: 'Alguem indica oficina para revisao de 20k do Dolphin em Belem?',
      likes: 5,
      comments: 4,
      shares: 0,
    );
  }
}
