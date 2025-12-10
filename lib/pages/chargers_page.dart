import 'package:flutter/material.dart';

import '../models/charger.dart';
import '../services/repository.dart';
import '../widgets/section_title.dart';

class ChargersPage extends StatelessWidget {
  const ChargersPage({super.key, required this.repository});

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carregadores'),
      ),
      body: FutureBuilder<List<Charger>>(
        future: repository.fetchChargers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar carregadores: ${snapshot.error}'),
            );
          }
          final chargers = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Pontos de energia'),
                const SizedBox(height: 8),
                Expanded(
                  child: chargers.isEmpty
                      ? const Center(
                          child: Text('Nenhum carregador cadastrado.'),
                        )
                      : ListView.separated(
                          itemBuilder: (_, index) =>
                              _ChargerTile(charger: chargers[index]),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemCount: chargers.length,
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

class _ChargerTile extends StatelessWidget {
  const _ChargerTile({required this.charger});

  final Charger charger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = charger.status == 'ativo'
        ? Colors.green.shade600
        : charger.status == 'manutencao'
            ? Colors.orange.shade700
            : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(charger.name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  charger.status,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            charger.address ?? 'Endereco nao informado',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (charger.connectorType != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.power_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(charger.connectorType!),
                    ],
                  ),
                ),
              if (charger.powerKw != null)
                Row(
                  children: [
                    const Icon(Icons.flash_on_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${charger.powerKw} kW'),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
