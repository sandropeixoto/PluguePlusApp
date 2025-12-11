import 'package:flutter/material.dart';
import 'package:plugueplus/widgets/circular_stat_card.dart';
import 'package:plugueplus/widgets/quick_action_button.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            expandedHeight: 150.0,
            backgroundColor: AppTheme.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text('Olá, Elara! 👋', style: AppTheme.themeData.textTheme.headlineMedium?.copyWith(color: AppTheme.pureWhite)),
              centerTitle: false,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Text('82%', style: AppTheme.themeData.textTheme.bodyLarge?.copyWith(color: AppTheme.primaryGreen)),
                    const SizedBox(width: 8),
                    const Icon(Icons.battery_charging_full, color: AppTheme.primaryGreen, size: 28),
                  ],
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // --- Botões de Ação Rápida ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuickActionButton(icon: Icons.ev_station, label: 'Carregadores', onPressed: () {}),
                      const SizedBox(width: 12),
                      QuickActionButton(icon: Icons.store, label: 'Lojas EV', onPressed: () {}),
                      const SizedBox(width: 12),
                      QuickActionButton(icon: Icons.people, label: 'Comunidade', onPressed: () {}),
                      const SizedBox(width: 12),
                      QuickActionButton(icon: Icons.map, label: 'Postos', onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text('Desempenho Sustentável', style: AppTheme.themeData.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // --- Gráficos Circulares ---
                  const Row(
                    children: [
                       CircularStatCard(
                        title: 'Nível da Bateria',
                        value: '82%',
                        percentage: 0.82,
                        color: AppTheme.primaryGreen,
                      ),
                      SizedBox(width: 12),
                      CircularStatCard(
                        title: 'Economia de CO₂',
                        value: '1.2t',
                        percentage: 0.65,
                        color: AppTheme.petroleumBlue,
                      ),
                      SizedBox(width: 12),
                      CircularStatCard(
                        title: 'Meta Mensal',
                        value: '90%',
                        percentage: 0.9,
                        color: AppTheme.lemonYellow,
                      ),
                    ],
                  ),
                   const SizedBox(height: 32),

                  Text('Destaque da Comunidade', style: AppTheme.themeData.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // --- Card de Destaque ---
                  Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       color: AppTheme.lightGray,
                       borderRadius: AppTheme.borderRadius,
                       boxShadow: AppTheme.softShadow,
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Review do novo Lucid Air: é tudo isso mesmo?", style: AppTheme.themeData.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.pureWhite)),
                         const SizedBox(height: 8),
                         Text("Por @ev_fanatic • 2h atrás", style: AppTheme.themeData.textTheme.bodySmall?.copyWith(color: AppTheme.pureWhite.withOpacity(0.6))),
                         const SizedBox(height: 12),
                         Text("Acabei de fazer um test-drive e minhas primeiras impressões são...", style: AppTheme.themeData.textTheme.bodyMedium),
                       ],
                     ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
