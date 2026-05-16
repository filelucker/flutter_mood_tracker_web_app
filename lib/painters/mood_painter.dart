import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodPainter extends CustomPainter {
  final MoodType moodType;
  final double animationValue; // Used for micro-interactions (0.0 to 1.0)

  MoodPainter({
    required this.moodType,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Apply animation scale: slight pulse effect based on animationValue
    // We scale the canvas around the center for a clean visual "pop"
    final scale = 0.9 + (0.1 * animationValue);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx, -center.dy);

    final radius = math.min(size.width, size.height) / 2;
    final color = moodType.color;

    final facePaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round;

    final eyePaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // 1. Draw Face Circle
    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, strokePaint);

    // 2. Eyes Math: Positioned symmetrically at 35% width and 25% height from center
    final eyeOffsetX = radius * 0.35;
    final eyeOffsetY = radius * 0.25;
    final eyeRadius = radius * 0.1;

    canvas.drawCircle(
      Offset(center.dx - eyeOffsetX, center.dy - eyeOffsetY),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffsetX, center.dy - eyeOffsetY),
      eyeRadius,
      eyePaint,
    );

    // 3. Mouth & Expressions
    switch (moodType) {
      case MoodType.happy:
        _drawHappyExpression(canvas, center, radius, strokePaint);
        break;
      case MoodType.neutral:
        _drawNeutralExpression(canvas, center, radius, strokePaint);
        break;
      case MoodType.sad:
        _drawSadExpression(canvas, center, radius, strokePaint);
        break;
    }

    canvas.restore();
  }

  void _drawHappyExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    // A simple upward arc for a smile
    // Rect defines the bounding box of the ellipse the arc is part of
    final rect = Rect.fromCircle(
      center: center.translate(0, radius * 0.1), 
      radius: radius * 0.5,
    );
    // Start angle: ~0.2 rad, Sweep angle: pi - 0.4 rad
    canvas.drawArc(rect, 0.2, math.pi - 0.4, false, paint);
  }

  void _drawNeutralExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    // A flat line for a neutral face
    final lineStart = Offset(center.dx - radius * 0.4, center.dy + radius * 0.35);
    final lineEnd = Offset(center.dx + radius * 0.4, center.dy + radius * 0.35);
    canvas.drawLine(lineStart, lineEnd, paint);
  }

  void _drawSadExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    // 1. Frown: An inverted quadratic bezier curve for a more "expressive" look than a simple arc
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.5);
    mouthPath.quadraticBezierTo(
      center.dx, center.dy + radius * 0.2, // Control point higher than ends
      center.dx + radius * 0.4, center.dy + radius * 0.5,
    );
    canvas.drawPath(mouthPath, paint);

    // 2. Eyebrows: Angled upwards towards the center to convey sadness
    final leftEyebrow = Path()
      ..moveTo(center.dx - radius * 0.5, center.dy - radius * 0.55)
      ..lineTo(center.dx - radius * 0.2, center.dy - radius * 0.4);
    canvas.drawPath(leftEyebrow, paint);

    final rightEyebrow = Path()
      ..moveTo(center.dx + radius * 0.5, center.dy - radius * 0.55)
      ..lineTo(center.dx + radius * 0.2, center.dy - radius * 0.4);
    canvas.drawPath(rightEyebrow, paint);
  }

  @override
  bool shouldRepaint(covariant MoodPainter oldDelegate) {
    return oldDelegate.moodType != moodType || oldDelegate.animationValue != animationValue;
  }
}
