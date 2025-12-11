import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, this.iconName});

  final String? iconName;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(iconName),
      size: 20,
      color: const Color(0xFF0F8F5F),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'handyman':
        return Icons.handyman_outlined;
      case 'build':
        return Icons.build_outlined;
      case 'construction':
        return Icons.construction_outlined;
      case 'bolt':
        return Icons.bolt_outlined;
      case 'electric_car':
        return Icons.electric_car_outlined;
      case 'ev_station':
        return Icons.ev_station_outlined;
      case 'power':
        return Icons.power_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
