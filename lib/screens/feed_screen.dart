import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidade'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Placeholder
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
            color: AppTheme.lightGray,
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Post Título ${index + 1}', style: AppTheme.themeData.textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text('Conteúdo do post em breve...', style: AppTheme.themeData.textTheme.bodyMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
