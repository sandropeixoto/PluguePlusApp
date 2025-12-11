import 'package:flutter/material.dart';

import '../models/service.dart';
import 'icon_text.dart';
import 'pill.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final Service service;

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
                child: const Icon(
                  Icons.store_mall_directory_outlined,
                  color: Color(0xFF0F8F5F),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      service.city != null
                          ? '${service.city}${service.state != null ? ', ${service.state}' : ''}'
                          : service.address ?? '',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(service.categoryName ?? 'Categoria'),
                backgroundColor: const Color(0xFFE9F7F0),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (service.description != null && service.description!.isNotEmpty)
            Text(service.description!, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              if (service.phone != null)
                IconText(icon: Icons.phone_outlined, text: service.phone!),
              if (service.site != null)
                IconText(icon: Icons.link, text: service.site!),
              if (service.status != null)
                Pill(text: service.status!, color: const Color(0xFF0F8F5F)),
            ],
          ),
        ],
      ),
    );
  }
}
