import '../models/category.dart';
import '../models/charger.dart';
import '../models/classified_ad.dart';
import '../models/classified_category.dart';
import '../models/classified_image.dart';
import '../models/post.dart';
import '../models/service.dart';
import '../models/user.dart';

class RepositorySnapshot {
  const RepositorySnapshot({
    required this.categories,
    required this.services,
    required this.chargers,
  });

  final List<Category> categories;
  final List<Service> services;
  final List<Charger> chargers;
}

/// Contrato generico para fontes de dados (API ou memoria).
abstract class Repository {
  Future<List<Category>> fetchCategories();
  Future<List<Service>> fetchServices();
  Future<List<Charger>> fetchChargers();
  Future<List<ClassifiedCategory>> fetchClassifiedCategories() async => [];
  Future<List<ClassifiedAd>> fetchClassifiedAds() async => [];
  Future<List<ClassifiedImage>> fetchClassifiedImages(int adId) async => [];
  Future<List<Post>> fetchPosts() async => [];
  Future<List<User>> fetchUsers() async => [];

  /// Conveniencia para carregar os dados usados na home de uma vez.
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
}
