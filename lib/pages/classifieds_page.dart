import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/classified_ad.dart';
import '../models/classified_category.dart';
import '../services/repository.dart';

class ClassifiedsPage extends StatefulWidget {
  const ClassifiedsPage({super.key, required this.repository});

  final Repository repository;

  @override
  State<ClassifiedsPage> createState() => _ClassifiedsPageState();
}

class _ClassifiedsPageState extends State<ClassifiedsPage> {
  late Future<_ClassifiedData> _future;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_ClassifiedData> _load() async {
    final categories = await widget.repository.fetchClassifiedCategories();
    final ads = await widget.repository.fetchClassifiedAds();
    return _ClassifiedData(categories: categories, ads: ads);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificados'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Novo anúncio'),
          ),
        ],
      ),
      body: FutureBuilder<_ClassifiedData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          final ads = _selectedCategoryId == null
              ? data.ads
              : data.ads.where((a) => a.categoryId == _selectedCategoryId).toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryChips(
                  categories: data.categories,
                  selectedId: _selectedCategoryId,
                  onSelected: (id) => setState(() => _selectedCategoryId = id),
                ),
                const SizedBox(height: 16),
                _AdsGrid(ads: ads),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClassifiedData {
  const _ClassifiedData({required this.categories, required this.ads});
  final List<ClassifiedCategory> categories;
  final List<ClassifiedAd> ads;
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ClassifiedCategory> categories;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Todas'),
          selected: selectedId == null,
          onSelected: (_) => onSelected(null),
        ),
        ...categories.map((c) {
          return ChoiceChip(
            label: Text(c.name),
            selected: selectedId == c.id,
            onSelected: (_) => onSelected(c.id),
          );
        }),
      ],
    );
  }
}

class _AdsGrid extends StatelessWidget {
  const _AdsGrid({required this.ads});

  final List<ClassifiedAd> ads;

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F7F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB8E2CE)),
        ),
        child: const Text('Nenhum anúncio encontrado.'),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final itemWidth = isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ads
              .map(
                (ad) => SizedBox(
                  width: itemWidth,
                  child: _AdCard(ad: ad),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AdCard extends StatelessWidget {
  const _AdCard({required this.ad});

  final ClassifiedAd ad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = ad.images.isNotEmpty ? ad.images.first : null;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EFE7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: 160,
              width: double.infinity,
              color: const Color(0xFFE9F7F0),
              child: imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF0F8F5F))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${ad.price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F8F5F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  ad.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Pill(
                      text: ad.status ?? 'ativo',
                      color: const Color(0xFF0F8F5F),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
