import 'package:flutter/material.dart';

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0x24FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(0, h / 2),
      Offset(w, h / 2),
      linePaint,
    );

    canvas.drawCircle(
      Offset(w / 2, h / 2),
      w * 0.085,
      linePaint,
    );

    final penaltyWidth = w * 0.59;
    final penaltyLeft = (w - penaltyWidth) / 2;
    final penaltyRight = penaltyLeft + penaltyWidth;
    final penaltyDepth = h * 0.165;

    final topPenalty = Path()
      ..moveTo(penaltyLeft, 0)
      ..lineTo(penaltyLeft, penaltyDepth)
      ..lineTo(penaltyRight, penaltyDepth)
      ..lineTo(penaltyRight, 0);

    canvas.drawPath(topPenalty, linePaint);

    final bottomPenalty = Path()
      ..moveTo(penaltyLeft, h)
      ..lineTo(penaltyLeft, h - penaltyDepth)
      ..lineTo(penaltyRight, h - penaltyDepth)
      ..lineTo(penaltyRight, h);

    canvas.drawPath(bottomPenalty, linePaint);


    final goalWidth = w * 0.27;
    final goalLeft = (w - goalWidth) / 2;
    final goalRight = goalLeft + goalWidth;
    final goalDepth = h * 0.055;

    final topGoal = Path()
      ..moveTo(goalLeft, 0)
      ..lineTo(goalLeft, goalDepth)
      ..lineTo(goalRight, goalDepth)
      ..lineTo(goalRight, 0);

    canvas.drawPath(topGoal, linePaint);

    final bottomGoal = Path()
      ..moveTo(goalLeft, h)
      ..lineTo(goalLeft, h - goalDepth)
      ..lineTo(goalRight, h - goalDepth)
      ..lineTo(goalRight, h);

    canvas.drawPath(bottomGoal, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}