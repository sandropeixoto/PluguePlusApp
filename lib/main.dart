import 'package:flutter/material.dart';
import 'package:plugueplus/screens/shell.dart';
import 'package:plugueplus/services/api_service.dart';
import 'package:plugueplus/services/repository.dart';
import 'package:plugueplus/theme/app_theme.dart';

void main() {
  final repository = Repository(apiService: ApiService());
  runApp(MainApp(repository: repository));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.repository});

  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const MainShell(),
    );
  }
}
