import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/chargers_page.dart';
import 'pages/classifieds_page.dart';
import 'pages/home_page.dart';
import 'pages/services_page.dart';
import 'pages/auth_page.dart';
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
      ClassifiedsPage(repository: repository),
    ];

    return MaterialApp(
      title: 'Plugue+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F8F5F)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF4F8F5),
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
            NavigationDestination(
              icon: Icon(Icons.class_outlined),
              label: 'Classificados',
            ),
          ],
        ),
        floatingActionButton: currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AuthPage(repository: repository),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF0F8F5F),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Entrar / Cadastrar'),
              )
            : null,
      ),
    );
  }
}
