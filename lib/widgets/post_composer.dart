import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostComposer extends StatelessWidget {
  const PostComposer({
    super.key,
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
