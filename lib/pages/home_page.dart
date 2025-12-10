import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/service.dart';
import '../services/repository.dart';
import '../widgets/info_card.dart';
import '../widgets/section_title.dart';
import '../widgets/service_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.repository});

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugue+'),
        centerTitle: true,
      ),
      body: FutureBuilder<RepositorySnapshot>(
        future: repository.fetchSnapshot(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }
          final data = snapshot.data!;
          final categories = data.categories;
          final services = data.services.take(3).toList();
          final chargers = data.chargers;

          return ListView(
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
                    value: data.services.length.toString(),
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
                child: categories.isEmpty
                    ? const Center(child: Text('Nenhuma categoria.'))
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            _CategoryChip(categories[index]),
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
          );
        },
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
