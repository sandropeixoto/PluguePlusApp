import 'package:flutter/material.dart';
import 'package:plugueplus/screens/charging_station_screen.dart';
import 'package:plugueplus/screens/classifieds_screen.dart';
import 'package:plugueplus/screens/dashboard_screen.dart';
import 'package:plugueplus/screens/feed_screen.dart';
import 'package:plugueplus/theme/app_theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    FeedScreen(),
    ClassifiedsScreen(),
    // Para demonstração, a tela de estação de carregamento pode ser acessada a partir de outra tela
    // ou adicionada aqui se fizer sentido no fluxo.
    // Provisoriamente, vou colocar a quarta tela aqui para garantir que ela funcione.
    ChargingStationScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_rounded),
            label: 'Comprar',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.ev_station_rounded),
            label: 'Recarga',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
