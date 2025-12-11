import 'package:flutter/material.dart';

class AdaptiveCards<T> extends StatelessWidget {
  const AdaptiveCards({
    super.key,
    required this.items,
    required this.emptyLabel,
    required this.itemBuilder,
  });

  final List<T> items;
  final String emptyLabel;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F7F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB8E2CE)),
        ),
        child: Text(emptyLabel),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 760;
        final cardWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map(
                (item) => SizedBox(width: cardWidth, child: itemBuilder(item)),
              )
              .toList(),
        );
      },
    );
  }
}
