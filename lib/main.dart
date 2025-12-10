import 'package:flutter/material.dart';

import 'pages/chargers_page.dart';
import 'pages/home_page.dart';
import 'pages/services_page.dart';
import 'services/api_repository.dart';
import 'services/in_memory_repository.dart';
import 'services/repository.dart';

void main() {
  runApp(const PluguePlusApp());
}

class PluguePlusApp extends StatefulWidget {
  const PluguePlusApp({super.key});

  @override
  State<PluguePlusApp> createState() => _PluguePlusAppState();
}

class _PluguePlusAppState extends State<PluguePlusApp> {
  late final Repository repository;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Tenta consumir a API php-crud-api; se nao conseguir, cai no fallback em memoria.
    repository = ApiRepository(fallback: InMemoryRepository());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(repository: repository),
      ServicesPage(repository: repository),
      ChargersPage(repository: repository),
    ];

    return MaterialApp(
      title: 'Plugue+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4965)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(child: pages[currentIndex]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) =>
              setState(() => currentIndex = index),
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
          ],
        ),
      ),
    );
  }
}
