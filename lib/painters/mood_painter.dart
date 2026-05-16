import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodPainter extends CustomPainter {
  final MoodType moodType;
  final double animationValue;

  MoodPainter({
    required this.moodType,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
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

    // 2. Eyes
    final eyeOffsetX = radius * 0.35;
    final eyeOffsetY = radius * 0.25;
    final eyeRadius = radius * 0.1;

    if (moodType == MoodType.tired) {
      // Tired eyes: Half-closed (arcs)
      final leftEyeRect = Rect.fromCircle(
          center: Offset(center.dx - eyeOffsetX, center.dy - eyeOffsetY),
          radius: eyeRadius);
      canvas.drawArc(leftEyeRect, math.pi, math.pi, false, strokePaint);

      final rightEyeRect = Rect.fromCircle(
          center: Offset(center.dx + eyeOffsetX, center.dy - eyeOffsetY),
          radius: eyeRadius);
      canvas.drawArc(rightEyeRect, math.pi, math.pi, false, strokePaint);
    } else {
      // Normal eyes
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
    }

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
      case MoodType.excited:
        _drawExcitedExpression(canvas, center, radius, strokePaint);
        break;
      case MoodType.tired:
        _drawTiredExpression(canvas, center, radius, strokePaint);
        break;
      case MoodType.angry:
        _drawAngryExpression(canvas, center, radius, strokePaint);
        break;
    }

    canvas.restore();
  }

  void _drawHappyExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    final rect = Rect.fromCircle(center: center.translate(0, radius * 0.1), radius: radius * 0.5);
    canvas.drawArc(rect, 0.2, math.pi - 0.4, false, paint);
  }

  void _drawNeutralExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawLine(
      Offset(center.dx - radius * 0.4, center.dy + radius * 0.35),
      Offset(center.dx + radius * 0.4, center.dy + radius * 0.35),
      paint,
    );
  }

  void _drawSadExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.5);
    mouthPath.quadraticBezierTo(center.dx, center.dy + radius * 0.2, center.dx + radius * 0.4, center.dy + radius * 0.5);
    canvas.drawPath(mouthPath, paint);
    _drawEyebrows(canvas, center, radius, paint, true);
  }

  void _drawExcitedExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    // Large open smile
    final rect = Rect.fromCircle(center: center.translate(0, radius * 0.1), radius: radius * 0.5);
    paint.style = PaintingStyle.fill;
    canvas.drawArc(rect, 0, math.pi, true, paint);
    paint.style = PaintingStyle.stroke;
    
    // Raised eyebrows
    final browPath = Path();
    browPath.moveTo(center.dx - radius * 0.5, center.dy - radius * 0.5);
    browPath.quadraticBezierTo(center.dx - radius * 0.35, center.dy - radius * 0.6, center.dx - radius * 0.2, center.dy - radius * 0.5);
    canvas.drawPath(browPath, paint);
    
    final browPathRight = Path();
    browPathRight.moveTo(center.dx + radius * 0.2, center.dy - radius * 0.5);
    browPathRight.quadraticBezierTo(center.dx + radius * 0.35, center.dy - radius * 0.6, center.dx + radius * 0.5, center.dy - radius * 0.5);
    canvas.drawPath(browPathRight, paint);
  }

  void _drawTiredExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    // Small flat line mouth
    canvas.drawLine(
      Offset(center.dx - radius * 0.2, center.dy + radius * 0.4),
      Offset(center.dx + radius * 0.2, center.dy + radius * 0.4),
      paint,
    );
  }

  void _drawAngryExpression(Canvas canvas, Offset center, double radius, Paint paint) {
    // Downward curved mouth
    final rect = Rect.fromCircle(center: center.translate(0, radius * 0.6), radius: radius * 0.3);
    canvas.drawArc(rect, math.pi + 0.5, math.pi - 1.0, false, paint);
    
    // Angry eyebrows: Angled downwards towards center
    canvas.drawLine(Offset(center.dx - radius * 0.5, center.dy - radius * 0.5), Offset(center.dx - radius * 0.2, center.dy - radius * 0.45), paint);
    canvas.drawLine(Offset(center.dx + radius * 0.5, center.dy - radius * 0.5), Offset(center.dx + radius * 0.2, center.dy - radius * 0.45), paint);
  }

  void _drawEyebrows(Canvas canvas, Offset center, double radius, Paint paint, bool sad) {
    if (sad) {
      canvas.drawLine(Offset(center.dx - radius * 0.5, center.dy - radius * 0.55), Offset(center.dx - radius * 0.2, center.dy - radius * 0.4), paint);
      canvas.drawLine(Offset(center.dx + radius * 0.5, center.dy - radius * 0.55), Offset(center.dx + radius * 0.2, center.dy - radius * 0.4), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MoodPainter oldDelegate) {
    return oldDelegate.moodType != moodType || oldDelegate.animationValue != animationValue;
  }
}
