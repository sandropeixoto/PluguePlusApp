import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/classified_ad.dart';
import '../models/classified_category.dart';
import '../services/repository.dart';
import '../services/upload_service.dart';
import '../models/user.dart';

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
            onPressed: () => _openNewAdSheet(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Novo anuncio'),
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
              : data.ads
                    .where((a) => a.categoryId == _selectedCategoryId)
                    .toList();
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

  void _openNewAdSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: _NewAdForm(
            repository: widget.repository,
            onCreated: () {
              setState(() {
                _future = _load();
              });
            },
          ),
        );
      },
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
        child: const Text('Nenhum anuncio encontrado.'),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final itemWidth = isWide
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
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
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: Color(0xFF0F8F5F),
                      ),
                    ),
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

class _NewAdForm extends StatefulWidget {
  const _NewAdForm({required this.repository, required this.onCreated});

  final Repository repository;
  final VoidCallback onCreated;

  @override
  State<_NewAdForm> createState() => _NewAdFormState();
}

class _NewAdFormState extends State<_NewAdForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  ClassifiedCategory? _selectedCategory;
  bool _submitting = false;
  List<ClassifiedCategory> _categories = [];
  final List<String> _uploadedImages = [];
  final UploadService _uploadService = UploadService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await widget.repository.fetchClassifiedCategories();
    setState(() => _categories = cats);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Novo anuncio',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titulo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe o titulo' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descricao',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Preco',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ClassifiedCategory>(
                  initialValue: _selectedCategory,
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.name)),
                      )
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                  validator: (v) =>
                      v == null ? 'Selecione uma categoria' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Seu nome',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe seu nome' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Seu email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Informe o email' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Adicionar imagem'),
                    onPressed: _submitting ? null : _pickAndUploadImage,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _uploadedImages
                      .map(
                        (url) => Chip(
                          label: Text(
                            url.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: _submitting
                              ? null
                              : () {
                                  setState(() {
                                    _uploadedImages.remove(url);
                                  });
                                },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Publicar'),
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F8F5F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.bytes == null) return;

      final upload = await _uploadService.uploadClassifiedImage(
        bytes: file.bytes!,
        originalName: file.name,
      );
      setState(() {
        _uploadedImages.add(upload.url);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao subir imagem: $e')));
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final users = await widget.repository.fetchUsers();
      final email = _emailController.text.trim();
      final name = _nameController.text.trim();
      User user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => const User(id: 0, name: '', email: ''),
      );
      if (user.id == 0) {
        user = await widget.repository.createUser(name: name, email: email);
      }

      await widget.repository.createClassifiedAd(
        userId: user.id,
        categoryId: _selectedCategory!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0,
        imageUrls: _uploadedImages,
      );
      widget.onCreated();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao publicar: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
