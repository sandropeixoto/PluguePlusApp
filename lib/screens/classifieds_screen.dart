import 'package:flutter/material.dart';
import 'package:plugueplus/models/classified_ad.dart';
import 'package:plugueplus/models/classified_category.dart';
import 'package:plugueplus/services/api_repository.dart';
import 'package:plugueplus/theme/app_theme.dart';

class ClassifiedsScreen extends StatefulWidget {
  const ClassifiedsScreen({super.key});

  @override
  State<ClassifiedsScreen> createState() => _ClassifiedsScreenState();
}

class _ClassifiedsScreenState extends State<ClassifiedsScreen> {
  final ApiRepository _apiRepository = ApiRepository();
  late Future<void> _initialLoadFuture;

  List<ClassifiedCategory> _categories = [];
  List<ClassifiedAd> _ads = [];
  int? _selectedCategoryId;
  bool _isAdsLoading = false;

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Fetch both categories and initial ads in parallel
    final results = await Future.wait([
      _apiRepository.fetchClassifiedCategories(),
      _apiRepository.fetchClassifiedAds(),
    ]);
    if (mounted) {
      setState(() {
        _categories = results[0] as List<ClassifiedCategory>;
        _ads = results[1] as List<ClassifiedAd>;
      });
    }
  }

  Future<void> _filterAds(int? categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _isAdsLoading = true; // Show loader for ads
    });

    try {
      final ads = await _apiRepository.fetchClassifiedAds(categoryId: categoryId);
      if (mounted) {
        setState(() {
          _ads = ads;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao filtrar anúncios: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdsLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificados'),
      ),
      body: FutureBuilder<void>(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              _buildCategoryChips(),

              const SizedBox(height: 16),

              // Ads List
              Expanded(
                child: _isAdsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildAdsList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // "Todos" Chip
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: const Text('Todos'),
                selected: _selectedCategoryId == null,
                onSelected: (selected) {
                  if (selected) {
                    _filterAds(null);
                  }
                },
              ),
            ),
            // Category Chips
            ..._categories.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category.name),
                    selected: _selectedCategoryId == category.id,
                    onSelected: (selected) {
                      if (selected) {
                        _filterAds(category.id);
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsList() {
    if (_ads.isEmpty) {
      return const Center(
        child: Text('Nenhum anúncio encontrado.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _ads.length,
      itemBuilder: (context, index) {
        final ad = _ads[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              if (ad.images.isNotEmpty)
                Image.network(
                  ad.images.first, // Show the first image
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                      height: 180,
                      child: Center(child: Icon(Icons.error_outline))),
                )
              else
                const SizedBox(
                    height: 180,
                    child: Center(child: Icon(Icons.image_not_supported))),

              // Details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${ad.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    if (ad.categoryName != null)
                      Text(
                        ad.categoryName!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
