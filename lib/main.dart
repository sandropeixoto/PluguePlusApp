import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/api_repository.dart';
import 'services/in_memory_repository.dart';
import 'services/repository.dart';
import 'widgets/app_shell.dart';

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

  @override
  void initState() {
    super.initState();
    // Tenta consumir a API php-crud-api; se nao conseguir, cai no fallback em memoria.
    repository = ApiRepository(fallback: InMemoryRepository());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugue+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F8F5F)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF4F8F5),
      ),
      home: AppShell(repository: repository),
    );
  }
}
