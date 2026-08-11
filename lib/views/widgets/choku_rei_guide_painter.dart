import 'dart:math';
import 'package:flutter/material.dart';

/// Exibe o guia de traços do Choku Rei com o corpo do símbolo e setas numeradas.
///
/// O símbolo é desenhado em vetorial completo com:
/// - A barra horizontal superior, o haste vertical e a espiral central.
/// - Setas direcionais numeradas (1, 2, 3) em tom cinza/dourado.
class ChokuReiGuide extends StatelessWidget {
  final Color strokeColor;
  final Color guideLineColor;

  const ChokuReiGuide({
    super.key,
    this.strokeColor = const Color(0xFFB0BEC5), // Setas e números em Cinza
    this.guideLineColor = const Color(0x998A2BE2), // Traço do símbolo em Púrpura Escuro
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChokuReiPainter(
        strokeColor: strokeColor,
        guideLineColor: guideLineColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _ChokuReiPainter extends CustomPainter {
  final Color strokeColor;
  final Color guideLineColor;

  const _ChokuReiPainter({
    required this.strokeColor,
    required this.guideLineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final base = min(size.width, size.height);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final oy = -base * 0.04;

    // ── Desenhar o Corpo do Símbolo Choku Rei ──
    final symbolPaint = Paint()
      ..color = guideLineColor
      ..strokeWidth = base * 0.024
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // 1. Linha Horizontal Superior (Esquerda -> Direita)
    final topY = cy + oy - 0.40 * base;
    final startX = cx - 0.32 * base;
    final stemX = cx - 0.02 * base;
    path.moveTo(startX, topY);
    path.lineTo(stemX, topY);

    // 2. Haste Vertical (Topo -> Fundo)
    final bottomY = cy + oy + 0.38 * base;
    path.lineTo(stemX, bottomY);

    // 3. Espiral Interna (3.5 voltas de baixo para dentro)
    final scx = cx - 0.02 * base;
    final scy = cy + oy + 0.08 * base;
    
    const maxAngle = 3.5 * 2 * pi;
    const steps = 120;
    const rStart = 0.30;
    const rEnd = 0.04;

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final angle = t * maxAngle + pi / 2; // começa embaixo (90°)
      final r = (rStart - (rStart - rEnd) * t) * base;
      final px = scx + cos(angle) * r;
      final py = scy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }

    canvas.drawPath(path, symbolPaint);

    // ── Setas Numeradas (Cinza) ──

    // Seta 1: Horizontal Superior (Aponta para a Direita)
    _arrow(
      canvas, base,
      from: Offset(cx - 0.32 * base, cy + oy - 0.46 * base),
      to:   Offset(cx - 0.04 * base, cy + oy - 0.46 * base),
      label: '1',
      labelAbove: true,
    );

    // Seta 2: Vertical Descendente (Aponta para Baixo)
    _arrow(
      canvas, base,
      from: Offset(cx - 0.08 * base, cy + oy - 0.35 * base),
      to:   Offset(cx - 0.08 * base, cy + oy + 0.35 * base),
      label: '2',
      labelAbove: false,
    );

    // Seta 3: Curva da Espiral (Aponta para dentro)
    _arrowCurved(canvas, base, scx, scy, oy);
  }

  // ── Seta Reta Cinza com Número ──────────────────────────────────────

  void _arrow(
    Canvas canvas,
    double base, {
    required Offset from,
    required Offset to,
    required String label,
    required bool labelAbove,
  }) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = base * 0.020
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(from, to, paint);

    final dir = to - from;
    final len = dir.distance;
    if (len > 0) {
      final norm = dir / len;
      final perp = Offset(-norm.dy, norm.dx);
      final hs = base * 0.045;
      final head = Path()
        ..moveTo(to.dx, to.dy)
        ..lineTo((to - norm * hs + perp * (hs * 0.45)).dx,
                  (to - norm * hs + perp * (hs * 0.45)).dy)
        ..moveTo(to.dx, to.dy)
        ..lineTo((to - norm * hs - perp * (hs * 0.45)).dx,
                  (to - norm * hs - perp * (hs * 0.45)).dy);
      canvas.drawPath(head, paint);
    }

    final fontSize = (base * 0.075).clamp(12.0, 20.0);
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

    final Offset labelPos;
    if (labelAbove) {
      labelPos = Offset(from.dx - tp.width / 2, from.dy - tp.height - base * 0.015);
    } else {
      labelPos = Offset(from.dx - tp.width - base * 0.02, from.dy - tp.height / 2);
    }
    tp.paint(canvas, labelPos);
  }

  // ── Seta 3: Arco Curvo Cinza na Espiral ─────────────────────────────

  void _arrowCurved(
      Canvas canvas, double base, double scx, double scy, double oy) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = base * 0.020
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const rExt = 0.33;
    final angleStart = -pi * 0.10;
    final angleEnd   =  pi * 0.40;

    const steps = 30;
    final points = List.generate(steps + 1, (i) {
      final t = i / steps;
      final angle = angleStart + (angleEnd - angleStart) * t;
      return Offset(
        scx + cos(angle) * rExt * base,
        scy + sin(angle) * rExt * base,
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
      final hs = base * 0.045;
      final head = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((tip - norm * hs + perp * (hs * 0.45)).dx,
                  (tip - norm * hs + perp * (hs * 0.45)).dy)
        ..moveTo(tip.dx, tip.dy)
        ..lineTo((tip - norm * hs - perp * (hs * 0.45)).dx,
                  (tip - norm * hs - perp * (hs * 0.45)).dy);
      canvas.drawPath(head, paint);
    }

    final mid = points[steps ~/ 2];
    final fontSize = (base * 0.075).clamp(12.0, 20.0);
    final tp = TextPainter(
      text: TextSpan(
        text: '3',
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
    tp.paint(canvas, Offset(mid.dx + base * 0.03, mid.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_ChokuReiPainter old) =>
      old.strokeColor != strokeColor || old.guideLineColor != guideLineColor;
}
