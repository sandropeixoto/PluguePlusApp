import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChargingStationScreen extends StatelessWidget {
  const ChargingStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1617833419013-abc195a75a74?q=80&w=2940&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo com Glassmorphism
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.35),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.graphiteGray.withOpacity(0.85),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estação de Carga Rápida', style: AppTheme.themeData.textTheme.headlineLarge),
                          const SizedBox(height: 20),
                          Text('Detalhes da estação em breve...', style: AppTheme.themeData.textTheme.bodyLarge),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: AppTheme.themeData.elevatedButtonTheme.style?.copyWith(
                              backgroundColor: WidgetStateProperty.all(AppTheme.primaryGreen),
                              minimumSize: WidgetStateProperty.all(const Size(double.infinity, 60)),
                            ),
                            child: const Text('Iniciar Carregamento'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
           Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.pureWhite, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
