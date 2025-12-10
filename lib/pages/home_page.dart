import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/service.dart';
import '../services/in_memory_repository.dart';
import '../widgets/info_card.dart';
import '../widgets/section_title.dart';
import '../widgets/service_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.repository});

  final InMemoryRepository repository;

  @override
  Widget build(BuildContext context) {
    final categories = repository.listCategories();
    final services = repository.listServices().take(3).toList();
    final chargers = repository.listChargers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugue+'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle('Resumo'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              InfoCard(
                label: 'Categorias',
                value: categories.length.toString(),
                icon: Icons.category_outlined,
              ),
              InfoCard(
                label: 'Servicos',
                value: services.length.toString(),
                icon: Icons.store_mall_directory_outlined,
              ),
              InfoCard(
                label: 'Carregadores',
                value: chargers.length.toString(),
                icon: Icons.ev_station_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionTitle('Categorias'),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => _CategoryChip(categories[index]),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: categories.length,
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Servicos em destaque'),
          ...services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ServiceTile(service: service),
            ),
          ),
          if (services.isEmpty)
            const Text('Nenhum servico cadastrado ainda.'),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(this.category);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(category.name),
      avatar: const Icon(Icons.bolt, size: 18),
    );
  }
}
