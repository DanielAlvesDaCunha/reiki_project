import 'dart:math';
import 'package:flutter/material.dart';

/// Exibe o guia de traços do Choku Rei com setas numeradas.
///
/// O símbolo é desenhado em vetorial puro (sem imagem).
/// 3 setas indicam a sequência e direção de cada traço.
class ChokuReiGuide extends StatelessWidget {
  final Color strokeColor;

  const ChokuReiGuide({
    super.key,
    this.strokeColor = const Color(0xFFB388FF),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChokuReiPainter(strokeColor: strokeColor),
      child: const SizedBox.expand(),
    );
  }
}

class _ChokuReiPainter extends CustomPainter {
  final Color strokeColor;

  const _ChokuReiPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final base = min(size.width, size.height);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final oy = -base * 0.04;

    // Centro da espiral
    final scx = cx - 0.03 * base;
    final scy = cy + oy + 0.07 * base;

    // ── Seta 1: horizontal longa no topo, aponta para direita ──
    // Posicionada acima da linha horizontal do símbolo
    _arrow(
      canvas, base,
      from: Offset(cx - 0.30 * base, cy + oy - 0.46 * base),
      to:   Offset(cx - 0.02 * base, cy + oy - 0.46 * base),
      label: '1',
      labelAbove: true,
    );

    // ── Seta 2: vertical longa à ESQUERDA da linha vertical,
    //            começa no topo e desce até o fundo ──
    _arrow(
      canvas, base,
      from: Offset(cx - 0.08 * base, cy + oy - 0.32 * base),
      to:   Offset(cx - 0.08 * base, cy + oy + 0.38 * base),
      label: '2',
      labelAbove: false,
    );

    // ── Seta 3: pequena seta curva na espiral externa, lado direito ──
    _arrowCurved(canvas, base, scx, scy, oy);
  }

  // ── Seta com cabeça e número ────────────────────────────────────────

  void _arrow(
    Canvas canvas,
    double base, {
    required Offset from,
    required Offset to,
    required String label,
    required bool labelAbove, // true = número acima/esquerda da seta
  }) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = base * 0.025
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(from, to, paint);

    // cabeça de seta na ponta (to)
    final dir = to - from;
    final len = dir.distance;
    if (len == 0) return;
    final norm = dir / len;
    final perp = Offset(-norm.dy, norm.dx);
    final hs = base * 0.055;
    final head = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo((to - norm * hs + perp * (hs * 0.55)).dx,
                (to - norm * hs + perp * (hs * 0.55)).dy)
      ..moveTo(to.dx, to.dy)
      ..lineTo((to - norm * hs - perp * (hs * 0.55)).dx,
                (to - norm * hs - perp * (hs * 0.55)).dy);
    canvas.drawPath(head, paint);

    // número junto ao início da seta (from)
    final fontSize = (base * 0.10).clamp(12.0, 22.0);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: strokeColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // seta horizontal → número acima do início
    // seta vertical   → número à esquerda do início
    final Offset labelPos;
    if (labelAbove) {
      // acima do ponto inicial
      labelPos = Offset(from.dx - tp.width / 2, from.dy - tp.height - base * 0.02);
    } else {
      // à esquerda do ponto inicial
      labelPos = Offset(from.dx - tp.width - base * 0.025, from.dy - tp.height / 2);
    }
    tp.paint(canvas, labelPos);
  }

  // ── Seta 3: arco curvo no lado direito da espiral externa ──────────
  // Segue a curvatura da espiral por ~90°, de cima para baixo-direita,
  // com cabeça de seta na ponta e número '3' ao lado.

  void _arrowCurved(
      Canvas canvas, double base, double scx, double scy, double oy) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = base * 0.025
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Arco na volta externa da espiral (~3h até ~6h = 0° até 90°)
    const rExt = 0.39;
    final angleStart = -pi * 0.10; // um pouco acima de 3h
    final angleEnd   =  pi * 0.40; // ~72° — bem abaixo de 3h

    const steps = 30;
    final points = List.generate(steps + 1, (i) {
      final t = i / steps;
      final angle = angleStart + (angleEnd - angleStart) * t;
      return Offset(
        scx + cos(angle) * rExt * base,
        scy + sin(angle) * rExt * base,
      );
    });

    // desenha o arco como polyline suave
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);

    // cabeça de seta na ponta final do arco
    final tip = points.last;
    final before = points[points.length - 2];
    final dir = tip - before;
    final len = dir.distance;
    if (len == 0) return;
    final norm = dir / len;
    final perp = Offset(-norm.dy, norm.dx);
    final hs = base * 0.055;
    final head = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((tip - norm * hs + perp * (hs * 0.55)).dx,
                (tip - norm * hs + perp * (hs * 0.55)).dy)
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((tip - norm * hs - perp * (hs * 0.55)).dx,
                (tip - norm * hs - perp * (hs * 0.55)).dy);
    canvas.drawPath(head, paint);

    // número '3' à direita do ponto médio do arco
    final mid = points[steps ~/ 2];
    final fontSize = (base * 0.10).clamp(12.0, 22.0);
    final tp = TextPainter(
      text: TextSpan(
        text: '3',
        style: TextStyle(
          color: strokeColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(mid.dx + base * 0.04, mid.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_ChokuReiPainter old) =>
      old.strokeColor != strokeColor;
}
