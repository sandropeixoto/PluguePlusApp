import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CircularStatCard extends StatelessWidget {
  final String title;
  final String value;
  final double percentage;
  final Color color;

  const CircularStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: AppTheme.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.lightGray.withOpacity(0.5),
              borderRadius: AppTheme.borderRadius,
              border: Border.all(color: AppTheme.pureWhite.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: percentage,
                        strokeWidth: 6,
                        backgroundColor: AppTheme.graphiteGray,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                      Center(
                        child: Text(
                          value,
                          style: AppTheme.themeData.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.pureWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(title, style: AppTheme.themeData.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
