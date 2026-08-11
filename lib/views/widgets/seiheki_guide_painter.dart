import 'dart:math';
import 'package:flutter/material.dart';

/// Exibe o guia de traços do Seiheki exatamente com os 9 traços numerados:
/// - Traço padrão escuro (corpo do símbolo)
/// - Setas direcionais e números em tom cinza elegante
class SeihekiGuide extends StatelessWidget {
  final Color strokeColor;
  final Color guideLineColor;

  const SeihekiGuide({
    super.key,
    this.strokeColor = const Color(0xFFB0BEC5), // Setas e números em Cinza
    this.guideLineColor = const Color(0xDD3D2060), // Traço do símbolo em tom Escuro/Púrpura
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SeihekiPainter(
        strokeColor: strokeColor,
        guideLineColor: guideLineColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _SeihekiPainter extends CustomPainter {
  final Color strokeColor;
  final Color guideLineColor;

  const _SeihekiPainter({
    required this.strokeColor,
    required this.guideLineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final base = min(size.width, size.height);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final oy = -base * 0.02;

    // ── Traço Padrão Escuro (Corpo do Seiheki) ──
    final symbolPaint = Paint()
      ..color = guideLineColor
      ..strokeWidth = base * 0.024
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Lado Esquerdo - Z-shape e perna
    final pathLeft = Path()
      ..moveTo(cx - 0.26 * base, cy + oy - 0.28 * base)
      ..lineTo(cx - 0.22 * base, cy + oy - 0.18 * base) // Traço 1
      ..lineTo(cx - 0.14 * base, cy + oy - 0.10 * base) // Traço 2
      ..lineTo(cx - 0.25 * base, cy + oy + 0.02 * base) // Traço 3
      ..lineTo(cx - 0.25 * base, cy + oy + 0.08 * base) // Traço 4
      ..cubicTo(
        cx - 0.10 * base, cy + oy + 0.08 * base,
        cx - 0.08 * base, cy + oy + 0.16 * base,
        cx - 0.15 * base, cy + oy + 0.25 * base,
      ) // Traço 5
      ..lineTo(cx - 0.24 * base, cy + oy + 0.42 * base); // Traço 6
    canvas.drawPath(pathLeft, symbolPaint);

    // Lado Direito - Grande crista e coluna vertical
    final pathSpine = Path()
      ..moveTo(cx - 0.32 * base, cy + oy - 0.40 * base)
      ..cubicTo(
        cx - 0.10 * base, cy + oy - 0.48 * base,
        cx + 0.12 * base, cy + oy - 0.45 * base,
        cx + 0.15 * base, cy + oy - 0.22 * base,
      )
      ..cubicTo(
        cx + 0.16 * base, cy + oy,
        cx + 0.16 * base, cy + oy + 0.25 * base,
        cx + 0.12 * base, cy + oy + 0.46 * base,
      ); // Traço 7
    canvas.drawPath(pathSpine, symbolPaint);

    // Lado Direito - Laço arredondado superior (Traço 8)
    final pathEarTop = Path()
      ..moveTo(cx + 0.15 * base, cy + oy - 0.22 * base)
      ..cubicTo(
        cx + 0.28 * base, cy + oy - 0.22 * base,
        cx + 0.28 * base, cy + oy - 0.04 * base,
        cx + 0.16 * base, cy + oy - 0.04 * base,
      );
    canvas.drawPath(pathEarTop, symbolPaint);

    // Lado Direito - Laço arredondado inferior (Traço 9)
    final pathEarBottom = Path()
      ..moveTo(cx + 0.16 * base, cy + oy - 0.04 * base)
      ..cubicTo(
        cx + 0.29 * base, cy + oy - 0.04 * base,
        cx + 0.29 * base, cy + oy + 0.16 * base,
        cx + 0.15 * base, cy + oy + 0.16 * base,
      );
    canvas.drawPath(pathEarBottom, symbolPaint);

    // ── Setas Numeradas em Cinza (1 a 9) ──

    // 1. Antena ponta esquerdo-superior
    _arrow(
      canvas, base,
      from: Offset(cx - 0.29 * base, cy + oy - 0.30 * base),
      to:   Offset(cx - 0.24 * base, cy + oy - 0.20 * base),
      label: '1',
      labelOffset: Offset(-0.03 * base, -0.02 * base),
    );

    // 2. Dobra Z superior
    _arrow(
      canvas, base,
      from: Offset(cx - 0.24 * base, cy + oy - 0.17 * base),
      to:   Offset(cx - 0.14 * base, cy + oy - 0.10 * base),
      label: '2',
      labelOffset: Offset(-0.03 * base, -0.01 * base),
    );

    // 3. Dobra Z média
    _arrow(
      canvas, base,
      from: Offset(cx - 0.14 * base, cy + oy - 0.09 * base),
      to:   Offset(cx - 0.25 * base, cy + oy + 0.01 * base),
      label: '3',
      labelOffset: Offset(0.02 * base, -0.02 * base),
    );

    // 4. Pequeno traço vertical esquerdo
    _arrow(
      canvas, base,
      from: Offset(cx - 0.27 * base, cy + oy + 0.01 * base),
      to:   Offset(cx - 0.27 * base, cy + oy + 0.08 * base),
      label: '4',
      labelOffset: Offset(-0.03 * base, 0),
    );

    // 5. Traço horizontal da cintura
    _arrow(
      canvas, base,
      from: Offset(cx - 0.24 * base, cy + oy + 0.10 * base),
      to:   Offset(cx - 0.10 * base, cy + oy + 0.10 * base),
      label: '5',
      labelOffset: Offset(0, 0.03 * base),
    );

    // 6. Perna inferior esquerda longa
    _arrow(
      canvas, base,
      from: Offset(cx - 0.13 * base, cy + oy + 0.17 * base),
      to:   Offset(cx - 0.21 * base, cy + oy + 0.38 * base),
      label: '6',
      labelOffset: Offset(0.03 * base, -0.01 * base),
    );

    // 7. Grande arco do topo até a base
    _arrowCurved(
      canvas, base,
      center: Offset(cx - 0.05 * base, cy + oy - 0.05 * base),
      radius: 0.35 * base,
      angleStart: -pi * 0.75,
      angleEnd: pi * 0.35,
      label: '7',
      labelOffset: Offset(-0.02 * base, 0.04 * base),
    );

    // 8. Laço arredondado superior direito
    _arrowCurved(
      canvas, base,
      center: Offset(cx + 0.18 * base, cy + oy - 0.13 * base),
      radius: 0.09 * base,
      angleStart: -pi * 0.45,
      angleEnd: pi * 0.45,
      label: '8',
      labelOffset: Offset(0.04 * base, 0),
    );

    // 9. Laço arredondado inferior direito
    _arrowCurved(
      canvas, base,
      center: Offset(cx + 0.18 * base, cy + oy + 0.06 * base),
      radius: 0.09 * base,
      angleStart: -pi * 0.45,
      angleEnd: pi * 0.45,
      label: '9',
      labelOffset: Offset(0.04 * base, 0),
    );
  }

  // ── Seta Reta Cinza com Número ──────────────────────────────────────

  void _arrow(
    Canvas canvas,
    double base, {
    required Offset from,
    required Offset to,
    required String label,
    required Offset labelOffset,
  }) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = base * 0.018
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(from, to, paint);

    final dir = to - from;
    final len = dir.distance;
    if (len > 0) {
      final norm = dir / len;
      final perp = Offset(-norm.dy, norm.dx);
      final hs = base * 0.040;
      final head = Path()
        ..moveTo(to.dx, to.dy)
        ..lineTo((to - norm * hs + perp * (hs * 0.45)).dx,
                  (to - norm * hs + perp * (hs * 0.45)).dy)
        ..moveTo(to.dx, to.dy)
        ..lineTo((to - norm * hs - perp * (hs * 0.45)).dx,
                  (to - norm * hs - perp * (hs * 0.45)).dy);
      canvas.drawPath(head, paint);
    }

    final fontSize = (base * 0.070).clamp(12.0, 20.0);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: strokeColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(color: Colors.black45, blurRadius: 3),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelPos = Offset(
      from.dx + labelOffset.dx - tp.width / 2,
      from.dy + labelOffset.dy - tp.height / 2,
    );
    tp.paint(canvas, labelPos);
  }

  // ── Seta Curva Cinza com Número ─────────────────────────────────────

  void _arrowCurved(
    Canvas canvas,
    double base, {
    required Offset center,
    required double radius,
    required double angleStart,
    required double angleEnd,
    required String label,
    required Offset labelOffset,
  }) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = base * 0.018
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const steps = 24;
    final points = List.generate(steps + 1, (i) {
      final t = i / steps;
      final angle = angleStart + (angleEnd - angleStart) * t;
      return Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
    });

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);

    final tip = points.last;
    final before = points[points.length - 2];
    final dir = tip - before;
    final len = dir.distance;
    if (len > 0) {
      final norm = dir / len;
      final perp = Offset(-norm.dy, norm.dx);
      final hs = base * 0.040;
      final head = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((tip - norm * hs + perp * (hs * 0.45)).dx,
                  (tip - norm * hs + perp * (hs * 0.45)).dy)
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((tip - norm * hs - perp * (hs * 0.45)).dx,
                  (tip - norm * hs - perp * (hs * 0.45)).dy);
      canvas.drawPath(head, paint);
    }

    final fontSize = (base * 0.070).clamp(12.0, 20.0);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: strokeColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(color: Colors.black45, blurRadius: 3),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final mid = points[steps ~/ 2];
    tp.paint(
      canvas,
      Offset(mid.dx + labelOffset.dx - tp.width / 2,
             mid.dy + labelOffset.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_SeihekiPainter old) =>
      old.strokeColor != strokeColor || old.guideLineColor != guideLineColor;
}
