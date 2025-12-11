import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ClassifiedsScreen extends StatelessWidget {
  const ClassifiedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carros à Venda'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de Filtros (Chips)
            SizedBox(
              height: 40,
              child: ListView( // Placeholder para chips
                scrollDirection: Axis.horizontal,
                children: ['Novo', 'Usado', 'Sedan', 'SUV', 'Tesla', 'NIO'].map((label) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(label: Text(label),), 
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text('Cards de carros em breve...', style: AppTheme.themeData.textTheme.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
