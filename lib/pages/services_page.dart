import 'package:flutter/material.dart';

import '../models/service.dart';
import '../services/repository.dart';
import '../widgets/section_title.dart';
import '../widgets/service_tile.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key, required this.repository});

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicos')),
      body: FutureBuilder<List<Service>>(
        future: repository.fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar servicos: ${snapshot.error}'),
            );
          }
          final services = snapshot.data ?? [];
          return Padding(
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemCount: services.length,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
