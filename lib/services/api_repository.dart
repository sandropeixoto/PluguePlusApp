import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/category.dart';
import '../models/charger.dart';
import '../models/classified_ad.dart';
import '../models/classified_category.dart';
import '../models/classified_image.dart';
import '../models/post.dart';
import '../models/service.dart';
import '../models/user.dart';
import '../models/parsers.dart';
import 'repository.dart';

/// Consome o php-crud-api hospedado em producao.
class ApiRepository implements Repository {
  ApiRepository({
    http.Client? client,
    this.baseUrl = ApiConfig.baseUrl,
    Repository? fallback,
  })  : _client = client ?? http.Client(),
        _fallback = fallback;

  final http.Client _client;
  final Repository? _fallback;
  final String baseUrl;

  Future<List<Category>>? _categories;
  Future<List<Service>>? _services;
  Future<List<Charger>>? _chargers;
  Future<List<Post>>? _posts;
  Future<List<User>>? _users;
  Future<List<ClassifiedCategory>>? _classifiedCategories;
  Future<List<ClassifiedAd>>? _classifiedAds;

  @override
  Future<List<Category>> fetchCategories() {
    return _categories ??= _fetchRecords<Category>(
      ApiConfig.categoriesTable,
      (json) => Category.fromJson(json),
    );
  }

  @override
  Future<List<Service>> fetchServices() {
    return _services ??= _fetchRecords<Service>(
      ApiConfig.servicesTable,
      (json) => Service.fromJson(json),
    );
  }

  @override
  Future<List<Charger>> fetchChargers() {
    return _chargers ??= _fetchRecords<Charger>(
      ApiConfig.chargersTable,
      (json) => Charger.fromJson(json),
    );
  }

  @override
  Future<List<Post>> fetchPosts() {
    return _posts ??= _fetchRecords<Post>(
      ApiConfig.postsTable,
      (json) => Post.fromJson(json),
    );
  }

  @override
  Future<List<User>> fetchUsers() {
    return _users ??= _fetchRecords<User>(
      ApiConfig.usersTable,
      (json) => User.fromJson(json),
    );
  }

  @override
  Future<List<ClassifiedCategory>> fetchClassifiedCategories() {
    return _classifiedCategories ??= _fetchRecords<ClassifiedCategory>(
      ApiConfig.classifiedCategoriesTable,
      (json) => ClassifiedCategory.fromJson(json),
    );
  }

  @override
  Future<List<ClassifiedAd>> fetchClassifiedAds() {
    return _classifiedAds ??= _fetchRecords<ClassifiedAd>(
      '${ApiConfig.classifiedAdsTable}?join=${ApiConfig.classifiedImagesTable}&join=${ApiConfig.classifiedCategoriesTable}',
      (json) => ClassifiedAd.fromJson(json),
    );
  }

  @override
  Future<List<ClassifiedImage>> fetchClassifiedImages(int adId) {
    return _fetchRecords<ClassifiedImage>(
      '${ApiConfig.classifiedImagesTable}?filter=classified_id,eq,$adId',
      (json) => ClassifiedImage.fromJson(json),
    );
  }

  @override
  Future<RepositorySnapshot> fetchSnapshot() async {
    final categories = await fetchCategories();
    final services = await fetchServices();
    final chargers = await fetchChargers();
    return RepositorySnapshot(
      categories: categories,
      services: services,
      chargers: chargers,
    );
  }

  @override
  Future<User> createUser({
    required String name,
    required String email,
    String? city,
    String? state,
    String? vehicleModel,
    String userType = 'owner',
  }) async {
    final payload = {
      'name': name,
      'email': email,
      'city': city,
      'state': state,
      'vehicle_model': vehicleModel,
      'user_type': userType,
      'password': '', // backend pode ignorar ou sobrescrever
    };
    final created = await _postRecord(ApiConfig.usersTable, payload);
    final user = User.fromJson(created);
    _users = null; // invalida cache
    return user;
  }

  @override
  Future<Post> createPost({
    required int userId,
    required String content,
    String? imageUrl,
  }) async {
    final payload = {
      'user_id': userId,
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
    };
    final created = await _postRecord(ApiConfig.postsTable, payload);
    _posts = null;
    return Post.fromJson(created);
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
    final payload = {
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
    };
    final created = await _postRecord(ApiConfig.classifiedAdsTable, payload);
    final adId = parseInt(created['id']);

    // cria imagens vinculadas
    for (var i = 0; i < imageUrls.length; i++) {
      await _postRecord(ApiConfig.classifiedImagesTable, {
        'classified_id': adId,
        'image_path': imageUrls[i],
        'is_main': i == 0 ? 1 : 0,
      });
    }
    _classifiedAds = null;
    _classifiedImages = null;
    return ClassifiedAd.fromJson(created);
  }

  Future<List<T>> _fetchRecords<T>(
    String table,
    T Function(Map<String, dynamic>) parser,
  ) async {
    final separator = table.contains('?') ? '&' : '?';
    final uri = Uri.parse('$baseUrl/records/$table${separator}transform=1');
    try {
      final response = await _client.get(uri);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Erro ${response.statusCode} ao buscar $table: ${response.body}',
        );
      }
      final decoded = jsonDecode(response.body);
      final records = _extractRecords(decoded, table);
      return records.map((item) => parser(item)).toList();
    } catch (error) {
      if (_fallback != null) {
        // Fallback para os dados em memoria quando a API nao responde.
        if (T == Category) return (await _fallback!.fetchCategories()) as List<T>;
        if (T == Service) return (await _fallback!.fetchServices()) as List<T>;
        if (T == Charger) return (await _fallback!.fetchChargers()) as List<T>;
        if (T == Post) return (await _fallback!.fetchPosts()) as List<T>;
        if (T == User) return (await _fallback!.fetchUsers()) as List<T>;
        if (T == ClassifiedCategory) {
          return (await _fallback!.fetchClassifiedCategories()) as List<T>;
        }
        if (T == ClassifiedAd) {
          return (await _fallback!.fetchClassifiedAds()) as List<T>;
        }
        if (T == ClassifiedImage) {
          return (await _fallback!.fetchClassifiedImages(0)) as List<T>;
        }
      }
      rethrow;
    }
  }

  List<Map<String, dynamic>> _extractRecords(dynamic decoded, String table) {
    if (decoded is Map<String, dynamic>) {
      if (decoded['records'] is List) {
        return (decoded['records'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
      if (decoded[table] is List) {
        return (decoded[table] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
      final firstList = decoded.values.firstWhere(
        (value) => value is List,
        orElse: () => null,
      );
      if (firstList is List) {
        return firstList.whereType<Map<String, dynamic>>().toList();
      }
    }
    throw const FormatException('Resposta inesperada da API');
  }
}
