import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0F8F5F)),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
