import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/category.dart';
import '../models/charger.dart';
import '../models/home_data.dart';
import '../models/post.dart';
import '../models/service.dart';
import '../models/user.dart';
import '../services/repository.dart';
import '../services/upload_service.dart';
import '../widgets/adaptive_cards.dart';
import '../widgets/charger_card.dart';
import '../widgets/hero_stat.dart';
import '../widgets/post_composer.dart';
import '../widgets/posts_carousel.dart';
import '../widgets/search_card.dart';
import '../widgets/section_header.dart';
import '../widgets/service_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.repository});

  final Repository repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<HomeData> _future;
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

  Future<HomeData> _loadData() async {
    final snapshot = await widget.repository.fetchSnapshot();
    final posts = await widget.repository.fetchPosts();
    final users = await widget.repository.fetchUsers();
    return HomeData(
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
      body: FutureBuilder<HomeData>(
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
                  child: SearchCard(
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
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
                  child: SectionHeader(
                    title: 'Servicos Disponiveis',
                    icon: Icons.handshake_outlined,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AdaptiveCards<Service>(
                    items: filteredServices,
                    emptyLabel: 'Nenhum servico encontrado.',
                    itemBuilder: (service) => ServiceCard(service: service),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 4),
                  child: SectionHeader(
                    title: 'Pontos de Recarga',
                    icon: Icons.ev_station_outlined,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AdaptiveCards<Charger>(
                    items: filteredChargers,
                    emptyLabel: 'Nenhum ponto de recarga encontrado.',
                    itemBuilder: (charger) => ChargerCard(charger: charger),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SectionHeader(
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
                  child: PostsCarousel(posts: data.posts, users: data.users),
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
      final cityMatch =
          cityFilter.isEmpty ||
          (service.city?.toLowerCase().contains(cityFilter) ?? false);
      final categoryMatch =
          _selectedCategoryId == null ||
          service.categoryId == _selectedCategoryId;
      return cityMatch && categoryMatch;
    }).toList();
  }

  List<Charger> _applyFiltersChargers(List<Charger> chargers) {
    final cityFilter = _cityController.text.trim().toLowerCase();
    return chargers.where((charger) {
      final cityMatch =
          cityFilter.isEmpty ||
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
          child: PostComposer(
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao enviar imagem: $e')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao publicar: $e')));
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Widget _buildHero(HomeData data) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B8F5F), Color(0xFF11B67A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            ),
          ),
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/background_pattern.svg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
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
                    HeroStat(
                      label: 'Servicos',
                      value: data.services.length.toString(),
                    ),
                    const SizedBox(width: 12),
                    HeroStat(
                      label: 'Recargas',
                      value: data.chargers.length.toString(),
                    ),
                    const SizedBox(width: 12),
                    HeroStat(
                      label: 'Comunidade',
                      value: data.posts.length.toString(),
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
