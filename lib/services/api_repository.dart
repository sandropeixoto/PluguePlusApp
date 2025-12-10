import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/category.dart';
import '../models/charger.dart';
import '../models/post.dart';
import '../models/service.dart';
import '../models/user.dart';
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

  Future<List<T>> _fetchRecords<T>(
    String table,
    T Function(Map<String, dynamic>) parser,
  ) async {
    final uri = Uri.parse('$baseUrl/records/$table?transform=1');
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
