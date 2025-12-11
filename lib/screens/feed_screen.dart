import 'package:flutter/material.dart';
import 'package:plugueplus/models/post.dart';
import 'package:plugueplus/services/api_repository.dart';
import 'package:plugueplus/theme/app_theme.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Post>> _postsFuture;
  final ApiRepository _apiRepository = ApiRepository();

  @override
  void initState() {
    super.initState();
    _postsFuture = _apiRepository.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed da Comunidade'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar o feed: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum post encontrado.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
                color: AppTheme.lightGray,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.content, // Exibe o conteudo do post
                        style: AppTheme.themeData.textTheme.bodyLarge,
                      ),
                      if (post.imageUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: ClipRRect(
                            borderRadius: AppTheme.borderRadius,
                            child: Image.network(post.imageUrl!),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        'Postado em: ${post.createdAt}', // Exemplo de metadados
                        style: AppTheme.themeData.textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
