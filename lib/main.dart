import 'package:flutter/material.dart';
import 'package:plugueplus/screens/shell.dart';
import 'package:plugueplus/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const MainShell(),
    );
  }
}
