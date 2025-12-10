import 'package:flutter/material.dart';

import '../models/service.dart';
import '../services/in_memory_repository.dart';
import '../widgets/section_title.dart';
import '../widgets/service_tile.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, required this.repository});

  final InMemoryRepository repository;

  @override
  Widget build(BuildContext context) {
    final services = repository.listServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Todos os servicos'),
            const SizedBox(height: 8),
            Expanded(
              child: services.isEmpty
                  ? const Center(child: Text('Nenhum servico cadastrado.'))
                  : ListView.separated(
                      itemBuilder: (_, index) =>
                          ServiceTile(service: services[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: services.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
