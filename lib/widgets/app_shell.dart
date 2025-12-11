import 'package:flutter/material.dart';

import '../pages/auth_page.dart';
import '../pages/chargers_page.dart';
import '../pages/classifieds_page.dart';
import '../pages/home_page.dart';
import '../pages/services_page.dart';
import '../services/repository.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.repository});

  final Repository repository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(repository: widget.repository),
      ServicesPage(repository: widget.repository),
      ChargersPage(repository: widget.repository),
      ClassifiedsPage(repository: widget.repository),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            label: 'Servicos',
          ),
          NavigationDestination(
            icon: Icon(Icons.ev_station_outlined),
            label: 'Carregadores',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_outlined),
            label: 'Classificados',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AuthPage(repository: widget.repository),
                  ),
                );
              },
              backgroundColor: const Color(0xFF0F8F5F),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Entrar / Cadastrar'),
            )
          : null,
    );
  }
}
