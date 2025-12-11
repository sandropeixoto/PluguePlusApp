import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/category.dart';
import '../models/charger.dart';
import '../models/post.dart';
import '../models/service.dart';
import '../models/user.dart';
import '../services/repository.dart';
import '../services/upload_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});

  final Repository repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<_HomeData> _future;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postContentController = TextEditingController();
  final TextEditingController _postNameController = TextEditingController();
  final TextEditingController _postEmailController = TextEditingController();
  final UploadService _uploadService = UploadService();
  int? _selectedCategoryId;
  bool _posting = false;
  String? _postImageUrl;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_HomeData> _loadData() async {
    final snapshot = await widget.repository.fetchSnapshot();
    final posts = await widget.repository.fetchPosts();
    final users = await widget.repository.fetchUsers();
    return _HomeData(
      categories: snapshot.categories,
      services: snapshot.services,
      chargers: snapshot.chargers,
      posts: posts,
      users: users,
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _postContentController.dispose();
    _postNameController.dispose();
    _postEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      body: FutureBuilder<_HomeData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }
          final data = snapshot.data!;
          final filteredServices = _applyFilters(data.services);
          final filteredChargers = _applyFiltersChargers(data.chargers);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(data)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchCard(
                    cityController: _cityController,
                    categories: data.categories,
                    selectedCategoryId: _selectedCategoryId,
                    onSearch: () => setState(() {}),
                    onCategoryChanged: (id) => setState(() {
                      _selectedCategoryId = id;
                    }),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                  child: _SectionHeader(
                    title: 'Servicos Disponiveis',
                    icon: Icons.handshake_outlined,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _AdaptiveCards<Service>(
                    items: filteredServices,
                    emptyLabel: 'Nenhum servico encontrado.',
                    itemBuilder: (service) => _ServiceCard(service: service),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
                  child: _SectionHeader(
                    title: 'Pontos de Recarga',
                    icon: Icons.ev_station_outlined,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _AdaptiveCards<Charger>(
                    items: filteredChargers,
                    emptyLabel: 'Nenhum ponto de recarga encontrado.',
                    itemBuilder: (charger) => _ChargerCard(charger: charger),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _SectionHeader(
                        title: 'Novidades da Comunidade',
                        icon: Icons.feed_outlined,
                      ),
                      TextButton.icon(
                        onPressed: _openNewPostSheet,
                        icon: const Icon(Icons.add_comment_outlined),
                        label: const Text('Nova postagem'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0F8F5F),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.launch_outlined),
                        label: const Text('Ver feed completo'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0F8F5F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: _PostsCarousel(
                    posts: data.posts,
                    users: data.users,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  List<Service> _applyFilters(List<Service> services) {
    final cityFilter = _cityController.text.trim().toLowerCase();
    return services.where((service) {
      final cityMatch = cityFilter.isEmpty ||
          (service.city?.toLowerCase().contains(cityFilter) ?? false);
      final categoryMatch =
          _selectedCategoryId == null || service.categoryId == _selectedCategoryId;
      return cityMatch && categoryMatch;
    }).toList();
  }

  List<Charger> _applyFiltersChargers(List<Charger> chargers) {
    final cityFilter = _cityController.text.trim().toLowerCase();
    return chargers.where((charger) {
      final cityMatch = cityFilter.isEmpty ||
          (charger.city?.toLowerCase().contains(cityFilter) ??
              charger.address?.toLowerCase().contains(cityFilter) ??
              false);
      return cityMatch;
    }).toList();
  }

  void _openNewPostSheet() {
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
          child: _PostComposer(
            onSubmit: _submitPost,
            onPickImage: _pickPostImage,
            contentController: _postContentController,
            nameController: _postNameController,
            emailController: _postEmailController,
            imageUrl: _postImageUrl,
            posting: _posting,
            clearImage: () => setState(() => _postImageUrl = null),
          ),
        );
      },
    );
  }

  Future<void> _pickPostImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.bytes == null) return;
      setState(() => _posting = true);
      final upload = await _uploadService.uploadPostImage(
        bytes: file.bytes!,
        originalName: file.name,
      );
      setState(() {
        _postImageUrl = upload.url;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar imagem: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _submitPost() async {
    final content = _postContentController.text.trim();
    final name = _postNameController.text.trim();
    final email = _postEmailController.text.trim();
    if (content.isEmpty || name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, email e mensagem.')),
      );
      return;
    }
    setState(() => _posting = true);
    try {
      final users = await widget.repository.fetchUsers();
      User user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => const User(id: 0, name: '', email: ''),
      );
      if (user.id == 0) {
        user = await widget.repository.createUser(name: name, email: email);
      }
      await widget.repository.createPost(
        userId: user.id,
        content: content,
        imageUrl: _postImageUrl,
      );
      _postContentController.clear();
      _postImageUrl = null;
      Navigator.of(context).maybePop();
      setState(() {
        _future = _loadData();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao publicar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Widget _buildHero(_HomeData data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B8F5F), Color(0xFF11B67A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: const Icon(Icons.bolt, color: Color(0xFF0B8F5F)),
              ),
              const SizedBox(width: 10),
              Text(
                'Plugue+',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_outline, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Bem-vindo ao Plugue+',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Conecte-se a servicos especializados e pontos de recarga com energia verde.',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.92),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroStat(
                label: 'Servicos',
                value: data.services.length.toString(),
              ),
              const SizedBox(width: 12),
              _HeroStat(
                label: 'Recargas',
                value: data.chargers.length.toString(),
              ),
              const SizedBox(width: 12),
              _HeroStat(
                label: 'Comunidade',
                value: data.posts.length.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeData {
  const _HomeData({
    required this.categories,
    required this.services,
    required this.chargers,
    required this.posts,
    required this.users,
  });

  final List<Category> categories;
  final List<Service> services;
  final List<Charger> chargers;
  final List<Post> posts;
  final List<User> users;
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.cityController,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSearch,
    required this.onCategoryChanged,
  });

  final TextEditingController cityController;
  final List<Category> categories;
  final int? selectedCategoryId;
  final VoidCallback onSearch;
  final ValueChanged<int?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buscar Servicos e Pontos de Recarga',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF0F3B2E),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: Color(0xFFF6F9F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      filled: true,
                      fillColor: Color(0xFFF6F9F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Todas as categorias'),
                      ),
                      ...categories.map(
                        (c) => DropdownMenuItem<int?>(
                          value: c.id,
                          child: Text(c.name),
                        ),
                      ),
                    ],
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F8F5F),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onSearch,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdaptiveCards<T> extends StatelessWidget {
  const _AdaptiveCards({
    required this.items,
    required this.emptyLabel,
    required this.itemBuilder,
  });

  final List<T> items;
  final String emptyLabel;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F7F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB8E2CE)),
        ),
        child: Text(emptyLabel),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 760;
        final cardWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map((item) => SizedBox(
                    width: cardWidth,
                    child: itemBuilder(item),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F8F5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store_mall_directory_outlined,
                    color: Color(0xFF0F8F5F)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      service.city != null
                          ? '${service.city}${service.state != null ? ', ${service.state}' : ''}'
                          : service.address ?? '',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(service.categoryName ?? 'Categoria'),
                backgroundColor: const Color(0xFFE9F7F0),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (service.description != null && service.description!.isNotEmpty)
            Text(
              service.description!,
              style: theme.textTheme.bodyMedium,
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              if (service.phone != null)
                _IconText(icon: Icons.phone_outlined, text: service.phone!),
              if (service.site != null)
                _IconText(icon: Icons.link, text: service.site!),
              if (service.status != null)
                _Pill(text: service.status!, color: const Color(0xFF0F8F5F)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChargerCard extends StatelessWidget {
  const _ChargerCard({required this.charger});

  final Charger charger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = charger.status == 'ativo'
        ? const Color(0xFF0F8F5F)
        : charger.status == 'manutencao'
            ? const Color(0xFFECA72C)
            : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F8F5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.ev_station, color: Color(0xFF0F8F5F)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      charger.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      charger.city != null
                          ? '${charger.city}${charger.state != null ? ', ${charger.state}' : ''}'
                          : charger.address ?? 'Endereco nao informado',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              _Pill(text: charger.status, color: badgeColor),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              if (charger.connectorType != null)
                _IconText(
                  icon: Icons.power_outlined,
                  text: charger.connectorType!,
                ),
              if (charger.powerKw != null)
                _IconText(
                  icon: Icons.flash_on_outlined,
                  text: '${charger.powerKw} kW',
                ),
              if (charger.costType != null)
                _IconText(
                  icon: Icons.payments_outlined,
                  text: charger.costType == 'pago'
                      ? 'Pago ${charger.costValue != null ? "(${charger.costValue}/h)" : ""}'
                      : 'Gratuito',
                ),
              if (charger.availability != null)
                _IconText(
                  icon: Icons.schedule_outlined,
                  text: charger.availability!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostsCarousel extends StatelessWidget {
  const _PostsCarousel({required this.posts, required this.users});

  final List<Post> posts;
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE9F7F0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFB8E2CE)),
          ),
          padding: const EdgeInsets.all(14),
          child: const Text('Nenhum post ainda.'),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, index) {
        final post = posts[index];
        final user = users.firstWhere(
          (u) => u.id == post.userId,
          orElse: () => User(
            id: 0,
            name: 'Usuario',
            email: '',
          ),
        );
        return SizedBox(
          width: 280,
          child: _PostCard(post: post, user: user),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemCount: posts.length,
    );
  }
}

class _PostComposer extends StatelessWidget {
  const _PostComposer({
    required this.onSubmit,
    required this.onPickImage,
    required this.clearImage,
    required this.contentController,
    required this.nameController,
    required this.emailController,
    required this.posting,
    this.imageUrl,
  });

  final VoidCallback onSubmit;
  final VoidCallback onPickImage;
  final VoidCallback clearImage;
  final TextEditingController contentController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool posting;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nova postagem',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Seu nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Seu email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Compartilhe sua experiencia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Adicionar imagem'),
                  onPressed: posting ? null : onPickImage,
                ),
                const SizedBox(width: 10),
                if (imageUrl != null)
                  Chip(
                    label: Text(
                      imageUrl!.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onDeleted: posting ? null : clearImage,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: posting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Publicar'),
                onPressed: posting ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F8F5F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.user});

  final Post post;
  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EFE7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0F8F5F).withOpacity(0.2),
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : '?',
                  style: const TextStyle(color: Color(0xFF0F8F5F)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (post.createdAt != null)
                      Text(
                        _formatDate(post.createdAt!),
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.share_outlined, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.content,
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          const SizedBox(height: 10),
          Row(
            children: [
              _IconText(icon: Icons.favorite_border, text: post.likes.toString()),
              const SizedBox(width: 14),
              _IconText(icon: Icons.mode_comment_outlined, text: post.comments.toString()),
              const SizedBox(width: 14),
              _IconText(icon: Icons.send_outlined, text: post.shares.toString()),
            ],
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0F8F5F)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F3B2E),
          ),
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0F8F5F)),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
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
