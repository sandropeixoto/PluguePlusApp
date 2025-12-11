import 'package:flutter/material.dart';

import '../models/charger.dart';
import 'icon_text.dart';
import 'pill.dart';

class ChargerCard extends StatelessWidget {
  const ChargerCard({super.key, required this.charger});

  final Charger charger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = charger.status == 'ativo'
        ? const Color(0xFF0F8F5F)
        : charger.status == 'manutencao'
        ? const Color(0xFFECA72C)
        : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EFE7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F8F5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.ev_station, color: Color(0xFF0F8F5F)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      charger.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      charger.city != null
                          ? '${charger.city}${charger.state != null ? ', ${charger.state}' : ''}'
                          : charger.address ?? 'Endereco nao informado',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Pill(text: charger.status, color: badgeColor),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              if (charger.connectorType != null)
                IconText(
                  icon: Icons.power_outlined,
                  text: charger.connectorType!,
                ),
              if (charger.powerKw != null)
                IconText(
                  icon: Icons.flash_on_outlined,
                  text: '${charger.powerKw} kW',
                ),
              if (charger.costType != null)
                IconText(
                  icon: Icons.payments_outlined,
                  text: charger.costType == 'pago'
                      ? 'Pago ${charger.costValue != null ? "(${charger.costValue}/h)" : ""}'
                      : 'Gratuito',
                ),
              if (charger.availability != null)
                IconText(
                  icon: Icons.schedule_outlined,
                  text: charger.availability!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
