import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  ScannerOverlayPainter({
    required this.scanWindow,
  });

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    // Затемнение экрана
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final outer = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final inner = Path()..addRect(scanWindow);
    final path = Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(path, paint);

    //Линии по углам квадрата
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;
    const cornerOffset = 0.0;

    // Левый верхний угол
    canvas.drawLine(
      scanWindow.topLeft + const Offset(0, cornerOffset),
      scanWindow.topLeft + Offset(0, cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      scanWindow.topLeft + const Offset(cornerOffset, 0),
      scanWindow.topLeft + Offset(cornerLength, 0),
      cornerPaint,
    );

    // Правый верхний угол
    canvas.drawLine(
      scanWindow.topRight + Offset(0, cornerOffset),
      scanWindow.topRight + Offset(0, cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      scanWindow.topRight + Offset(-cornerLength, 0),
      scanWindow.topRight + Offset(0, 0),
      cornerPaint,
    );

    // Левый нижний угол
    canvas.drawLine(
      scanWindow.bottomLeft + Offset(0, -cornerOffset),
      scanWindow.bottomLeft + Offset(0, -cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      scanWindow.bottomLeft + Offset(cornerOffset, 0),
      scanWindow.bottomLeft + Offset(cornerLength, 0),
      cornerPaint,
    );

    // Правый нижний угол
    canvas.drawLine(
      scanWindow.bottomRight + Offset(0, -cornerOffset),
      scanWindow.bottomRight + Offset(0, -cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      scanWindow.bottomRight + Offset(-cornerLength, 0),
      scanWindow.bottomRight + Offset(0, 0),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}