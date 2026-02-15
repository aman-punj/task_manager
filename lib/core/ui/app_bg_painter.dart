import 'package:flutter/material.dart';

class AppBgPainter extends CustomPainter {
  final bool isDark;

  AppBgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? const [
        Color(0xFF020617),
        Color(0xFF0F172A),
      ]
          : const [
        Color(0xFFF8FAFC),
        Color(0xFFE2E8F0),
      ],
    ).createShader(rect);

    canvas.drawRect(rect, paint);

    // Decorative blobs
    _drawBlob(canvas, size, offset: const Offset(-80, -80), scale: 1.3);
    _drawBlob(canvas, size, offset: const Offset(200, 100), scale: 1.0);
    _drawBlob(canvas, size, offset: const Offset(-120, 400), scale: 1.4);
  }

  void _drawBlob(Canvas canvas, Size size,
      {required Offset offset, double scale = 1}) {
    final paint = Paint()
      ..color = (isDark
          ? Colors.white.withOpacity(0.04)
          : Colors.white.withOpacity(0.6))
          .withOpacity(isDark ? 0.03 : 0.5);

    final path = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.3, size.height * 0.2) + offset,
        radius: 120 * scale,
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
