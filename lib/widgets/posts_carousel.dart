import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import 'icon_text.dart';

class PostsCarousel extends StatelessWidget {
  const PostsCarousel({super.key, required this.posts, required this.users});

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
          orElse: () => const User(id: 0, name: 'Usuario', email: ''),
        );
        return SizedBox(
          width: 280,
          child: PostCard(post: post, user: user),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemCount: posts.length,
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.user});

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
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
          Text(post.content, style: theme.textTheme.bodyMedium),
          const Spacer(),
          const SizedBox(height: 10),
          Row(
            children: [
              IconText(
                icon: Icons.favorite_border,
                text: post.likes.toString(),
              ),
              const SizedBox(width: 14),
              IconText(
                icon: Icons.mode_comment_outlined,
                text: post.comments.toString(),
              ),
              const SizedBox(width: 14),
              IconText(icon: Icons.send_outlined, text: post.shares.toString()),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
