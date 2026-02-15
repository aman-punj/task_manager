import 'package:flutter/material.dart';
import 'package:task_manager/core/ui/app_bg_painter.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPaint(
      painter: AppBgPainter(isDark: isDark),
      child: child,
    );
  }
}
