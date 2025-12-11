import 'package:plugueplus/models/classified_ad.dart';
import 'package:plugueplus/models/classified_category.dart';
import 'package:plugueplus/models/post.dart';
import 'package:plugueplus/services/api_service.dart';
import 'package:plugueplus/config/api_config.dart';

class ApiRepository {
  final ApiService _apiService = ApiService();

  Future<List<Post>> fetchPosts({int limit = 10, int page = 1}) async {
    try {
      final params = {
        '_limit': limit.toString(),
        '_page': page.toString(),
        '_sort': 'created_at:DESC',
      };
      final data = await _apiService.getData(ApiConfig.postsTable, params: params);
      return data.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar posts: $e');
      return [];
    }
  }

  Future<List<ClassifiedCategory>> fetchClassifiedCategories() async {
    try {
      final data = await _apiService.getData(ApiConfig.classifiedCategoriesTable);
      return data.map((json) => ClassifiedCategory.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar categorias de classificados: $e');
      return [];
    }
  }

  Future<List<ClassifiedAd>> fetchClassifiedAds({int? categoryId}) async {
    try {
      final params = {
        'join': '${ApiConfig.classifiedCategoriesTable},${ApiConfig.classifiedImagesTable}',
      };
      if (categoryId != null) {
        params['filter'] = 'category_id,eq,$categoryId';
      }

      final data = await _apiService.getData(ApiConfig.classifiedAdsTable, params: params);
      
      // Agrupa as imagens por anuncio
      final Map<int, ClassifiedAd> groupedAds = {};
      for (var json in data) {
        final ad = ClassifiedAd.fromJson(json);
        if (!groupedAds.containsKey(ad.id)) {
          groupedAds[ad.id] = ad;
        }
        // Adiciona a imagem a lista, se existir
        final imagePath = json['image_path'];
        if (imagePath != null) {
          final existingAd = groupedAds[ad.id]!;
          final updatedImages = List<String>.from(existingAd.images)..add('${ApiConfig.siteUrl}$imagePath');
          groupedAds[ad.id] = ClassifiedAd(
            id: existingAd.id,
            userId: existingAd.userId,
            categoryId: existingAd.categoryId,
            title: existingAd.title,
            description: existingAd.description,
            price: existingAd.price,
            status: existingAd.status,
            views: existingAd.views,
            expiresAt: existingAt: existingAd.expiresAt,
            createdAt: existingAd.createdAt,
            updatedAt: existingAd.updatedAt,
            images: updatedImages,
            categoryName: existingAd.categoryName,
          );
        }
      }

      return groupedAds.values.toList();

    } catch (e) {
      print('Erro ao buscar anuncios de classificados: $e');
      return [];
    }
  }
}
