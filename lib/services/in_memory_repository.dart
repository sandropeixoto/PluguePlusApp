import 'package:collection/collection.dart';

import '../models/category.dart';
import '../models/charger.dart';
import '../models/classified_ad.dart';
import '../models/classified_category.dart';
import '../models/classified_image.dart';
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
  final List<ClassifiedCategory> _classifiedCategories = [];
  final List<ClassifiedAd> _classifiedAds = [];
  final List<ClassifiedImage> _classifiedImages = [];

  List<Category> listCategories() => List.unmodifiable(_categories);
  List<Service> listServices() => List.unmodifiable(_services);
  List<Charger> listChargers() => List.unmodifiable(_chargers);
  List<User> listUsers() => List.unmodifiable(_users);
  List<Post> listPosts() => List.unmodifiable(_posts);
  List<ClassifiedCategory> listClassifiedCategories() =>
      List.unmodifiable(_classifiedCategories);
  List<ClassifiedAd> listClassifiedAds() => List.unmodifiable(_classifiedAds);
  List<ClassifiedImage> listClassifiedImages(int adId) => List.unmodifiable(
        _classifiedImages.where((img) => img.classifiedId == adId),
      );

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

  @override
  Future<List<ClassifiedCategory>> fetchClassifiedCategories() async =>
      listClassifiedCategories();

  @override
  Future<List<ClassifiedAd>> fetchClassifiedAds() async => listClassifiedAds();

  @override
  Future<List<ClassifiedImage>> fetchClassifiedImages(int adId) async =>
      listClassifiedImages(adId);

  @override
  Future<User> createUser({
    required String name,
    required String email,
    String? city,
    String? state,
    String? vehicleModel,
    String userType = 'owner',
  }) async {
    return createUserSync(
      name: name,
      email: email,
      city: city,
      state: state,
    );
  }

  @override
  Future<Post> createPost({
    required int userId,
    required String content,
    String? imageUrl,
  }) async {
    return createPostSync(
      userId: userId,
      content: content,
    );
  }

  @override
  Future<ClassifiedAd> createClassifiedAd({
    required int userId,
    required int categoryId,
    required String title,
    required String description,
    required double price,
    String status = 'active',
    List<String> imageUrls = const [],
  }) async {
    final ad = createClassifiedAdSync(
      userId: userId,
      categoryId: categoryId,
      title: title,
      description: description,
      price: price,
      status: status,
    );
    for (var i = 0; i < imageUrls.length; i++) {
      addClassifiedImage(
        classifiedId: ad.id,
        imagePath: imageUrls[i],
        isMain: i == 0,
      );
    }
    return ad;
  }

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

  User createUserSync({
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

  Post createPostSync({
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

  ClassifiedCategory createClassifiedCategory({
    required String name,
    required String slug,
    String? description,
    String? icon,
  }) {
    final nextId =
        _classifiedCategories.isEmpty ? 1 : _classifiedCategories.last.id + 1;
    final category = ClassifiedCategory(
      id: nextId,
      name: name,
      slug: slug,
      description: description,
      icon: icon,
    );
    _classifiedCategories.add(category);
    return category;
  }

  ClassifiedAd createClassifiedAdSync({
    required int userId,
    required int categoryId,
    required String title,
    required String description,
    required double price,
    String status = 'active',
  }) {
    final nextId = _classifiedAds.isEmpty ? 1 : _classifiedAds.last.id + 1;
    final category =
        _classifiedCategories.firstWhereOrNull((c) => c.id == categoryId);
    final ad = ClassifiedAd(
      id: nextId,
      userId: userId,
      categoryId: categoryId,
      title: title,
      description: description,
      price: price,
      status: status,
      createdAt: DateTime.now(),
      categoryName: category?.name,
      images: listClassifiedImages(nextId).map((e) => e.imagePath).toList(),
    );
    _classifiedAds.add(ad);
    return ad;
  }

  void addClassifiedImage({
    required int classifiedId,
    required String imagePath,
    bool isMain = false,
  }) {
    final nextId = _classifiedImages.isEmpty ? 1 : _classifiedImages.last.id + 1;
    final img = ClassifiedImage(
      id: nextId,
      classifiedId: classifiedId,
      imagePath: imagePath,
      isMain: isMain,
      createdAt: DateTime.now(),
    );
    _classifiedImages.add(img);
  }

  void _seed() {
    final userSandro = createUserSync(
      name: 'Sandro Peixoto',
      email: 'sandro@plugueplus.com',
      city: 'Belem',
      state: 'PA',
    );
    final userGabi = createUserSync(
      name: 'Gabriela Santos',
      email: 'gabi@plugueplus.com',
      city: 'Belem',
      state: 'PA',
    );

    final catEletrica = createCategory(name: 'Eletrica Automotiva', icon: 'bolt');
    final catOficinas = createCategory(name: 'Oficina Mecanica', icon: 'build');
    final catHospedagem = createCategory(name: 'Hospitalidade', icon: 'hotel');
    final catAcessorios = createCategory(name: 'Acessorios', icon: 'shopping');
    final classCatVeiculos =
        createClassifiedCategory(name: 'Veiculos', slug: 'veiculos');
    final classCatPecas =
        createClassifiedCategory(name: 'Pecas e Acessorios', slug: 'pecas');

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

    createPostSync(
      userId: userSandro.id,
      content: 'Instalei um carregador residencial ontem, foi rapido e seguro.',
      likes: 12,
      comments: 3,
      shares: 1,
    );
    createPostSync(
      userId: userGabi.id,
      content: 'Alguem indica oficina para revisao de 20k do Dolphin em Belem?',
      likes: 5,
      comments: 4,
      shares: 0,
    );

    final ad1 = createClassifiedAdSync(
      userId: userSandro.id,
      categoryId: classCatVeiculos.id,
      title: 'BYD Dolphin 2024 - impecavel',
      description: '80k km, revisoes em dia, carregador incluso.',
      price: 152000,
      status: 'active',
    );
    addClassifiedImage(
      classifiedId: ad1.id,
      imagePath: 'https://placehold.co/400x250?text=Dolphin',
      isMain: true,
    );
    final ad2 = createClassifiedAdSync(
      userId: userGabi.id,
      categoryId: classCatPecas.id,
      title: 'Cabo Tipo 2 - 7kW',
      description: 'Cabo pouco usado, comprei outro de 11kW.',
      price: 850.0,
      status: 'active',
    );
    addClassifiedImage(
      classifiedId: ad2.id,
      imagePath: 'https://placehold.co/400x250?text=Cabo+Tipo2',
      isMain: true,
    );
  }
}
