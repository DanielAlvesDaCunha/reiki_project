import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/drawing/drawing_event.dart';
import '../../viewmodels/drawing/drawing_state.dart';
import '../../viewmodels/drawing/drawing_viewmodel.dart';

/// Canvas de desenho com sistema de coordenadas fixo.
///
/// Coordenadas são centradas e normalizadas pelo lado MENOR do canvas.
/// Isso garante que o desenho mantém forma e posição ao rotacionar.
///
/// - 1 dedo  → desenhar (60fps via ValueNotifier)
/// - 2 dedos → zoom + pan
/// - Botão   → resetar zoom
class DrawingCanvas extends StatefulWidget {
  final String? symbolName;
  final String? symbolId;
  /// Atualizado com o scale atual a cada mudança de zoom.
  final ValueNotifier<double>? scaleNotifier;
  /// Incrementar este notifier força o canvas a resetar o zoom.
  final ValueNotifier<int>? resetTrigger;
  const DrawingCanvas({
    super.key,
    this.symbolName,
    this.symbolId,
    this.scaleNotifier,
    this.resetTrigger,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  Size _canvasSize = Size.zero;

  // ── Zoom/pan ──────────────────────────────────────────
  double _scale = 1.95;
  Offset _panOffset = Offset.zero; // em unidades normalizadas (base = min(w,h))
  bool _isZooming = false;

  double _gestureBaseScale = 1.0;
  Offset _gestureStartFocalNorm = Offset.zero;

  // ── Traço ativo (60fps) ───────────────────────────────
  final _activeData = ValueNotifier<_ActiveData>(const _ActiveData());

  /// screen pixel → coord normalizada centrada
  /// Origem = centro do canvas, 1 unidade = min(w,h) pixels
  Offset _screenToNorm(Offset screen) {
    if (_canvasSize == Size.zero) return Offset.zero;
    final base = min(_canvasSize.width, _canvasSize.height);
    return Offset(
      (screen.dx - _canvasSize.width / 2) / (_scale * base) + _panOffset.dx,
      (screen.dy - _canvasSize.height / 2) / (_scale * base) + _panOffset.dy,
    );
  }

  void _updateTransform(double scale, Offset pan) {
    _scale = scale;
    _panOffset = pan;
    _activeData.value = _activeData.value.withTransform(scale, pan);
    widget.scaleNotifier?.value = scale;
  }

  void _resetZoom() => setState(() => _updateTransform(1.95, Offset.zero));

  @override
  void initState() {
    super.initState();
    widget.resetTrigger?.addListener(_resetZoom);
  }

  @override
  void dispose() {
    widget.resetTrigger?.removeListener(_resetZoom);
    _activeData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingViewModel, DrawingState>(
      buildWhen: (prev, curr) =>
          prev.strokes != curr.strokes ||
          prev.selectedColor != curr.selectedColor ||
          prev.strokeWidth != curr.strokeWidth ||
          prev.showGuide != curr.showGuide,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
            final base = min(_canvasSize.width, _canvasSize.height);

            return Stack(
              children: [
                // ── Guia de traços — acompanha zoom/pan do canvas ──
                if (state.showGuide)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Transform.translate(
                        offset: Offset(
                          -_panOffset.dx * base * _scale,
                          -_panOffset.dy * base * _scale,
                        ),
                        child: Transform.scale(
                          scale: _scale,
                          alignment: Alignment.center,
                          child: _SymbolGuideLayer(symbolId: widget.symbolId),
                        ),
                      ),
                    ),
                  ),

                GestureDetector(
                  onScaleStart: (d) => _onScaleStart(d, state),
                  onScaleUpdate: (d) => _onScaleUpdate(d, state),
                  onScaleEnd: (d) => _onScaleEnd(d, context),
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _HistoryPainter(
                        strokes: state.strokes,
                        scale: _scale,
                        panOffset: _panOffset,
                      ),
                      foregroundPainter: _ActiveStrokePainter(_activeData),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Handlers de gesto ────────────────────────────────

  void _onScaleStart(ScaleStartDetails d, DrawingState state) {
    if (d.pointerCount >= 2) {
      _isZooming = true;
      _gestureBaseScale = _scale;
      _gestureStartFocalNorm = _screenToNorm(d.localFocalPoint);
      _activeData.value = _activeData.value.clearStroke();
    } else if (!state.isVerificar) {
      // Modo verificar é somente leitura — 1 dedo não desenha
      _isZooming = false;
      _activeData.value = _ActiveData(
        stroke: _ActiveStroke(
          points: [_screenToNorm(d.localFocalPoint)],
          color: state.selectedColor,
          strokeWidth: state.strokeWidth,
        ),
        scale: _scale,
        panOffset: _panOffset,
      );
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails d, DrawingState state) {
    // Segundo dedo apareceu durante o desenho → troca para zoom
    if (d.pointerCount >= 2 && !_isZooming) {
      _isZooming = true;
      _gestureBaseScale = _scale;
      _gestureStartFocalNorm = _screenToNorm(d.localFocalPoint);
      _activeData.value = _activeData.value.clearStroke();
      return;
    }

    if (_isZooming) {
      final base = min(_canvasSize.width, _canvasSize.height);
      final newScale = (_gestureBaseScale * d.scale).clamp(0.3, 8.0);

      // Ponto focal no canvas deve permanecer fixo na tela
      final newPanX = _gestureStartFocalNorm.dx -
          (d.localFocalPoint.dx - _canvasSize.width / 2) / (newScale * base);
      final newPanY = _gestureStartFocalNorm.dy -
          (d.localFocalPoint.dy - _canvasSize.height / 2) / (newScale * base);

      setState(() => _updateTransform(newScale, Offset(newPanX, newPanY)));
    } else {
      final current = _activeData.value.stroke;
      if (current == null) return;
      _activeData.value = _activeData.value.withStroke(
        current.copyWithPoint(_screenToNorm(d.localFocalPoint)),
      );
    }
  }

  void _onScaleEnd(ScaleEndDetails d, BuildContext context) {
    if (!_isZooming) {
      final finished = _activeData.value.stroke;
      _activeData.value = _activeData.value.clearStroke();
      if (finished != null && finished.points.length > 1) {
        context.read<DrawingViewModel>().add(
              DrawingStrokeCompleted(
                DrawingStroke(
                  points: finished.points,
                  color: finished.color,
                  strokeWidth: finished.strokeWidth,
                ),
              ),
            );
      }
    }
    _isZooming = false;
  }
}

// ── Modelo do traço ativo + transform ──────────────────

class _ActiveStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  const _ActiveStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  _ActiveStroke copyWithPoint(Offset p) => _ActiveStroke(
        points: [...points, p],
        color: color,
        strokeWidth: strokeWidth,
      );
}

class _ActiveData {
  final _ActiveStroke? stroke;
  final double scale;
  final Offset panOffset;

  const _ActiveData({
    this.stroke,
    this.scale = 1.0,
    this.panOffset = Offset.zero,
  });

  _ActiveData withStroke(_ActiveStroke s) =>
      _ActiveData(stroke: s, scale: scale, panOffset: panOffset);

  _ActiveData clearStroke() =>
      _ActiveData(stroke: null, scale: scale, panOffset: panOffset);

  _ActiveData withTransform(double s, Offset p) =>
      _ActiveData(stroke: stroke, scale: s, panOffset: p);
}

// ── Painters ───────────────────────────────────────────

class _HistoryPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final double scale;
  final Offset panOffset;

  _HistoryPainter({
    required this.strokes,
    required this.scale,
    required this.panOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _applyViewTransform(canvas, size, scale, panOffset);
    for (final s in strokes) {
      _drawStroke(canvas, s.points, s.color, s.strokeWidth, size);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HistoryPainter old) =>
      old.strokes != strokes ||
      old.scale != scale ||
      old.panOffset != panOffset;
}

class _ActiveStrokePainter extends CustomPainter {
  final ValueNotifier<_ActiveData> notifier;

  _ActiveStrokePainter(this.notifier) : super(repaint: notifier);

  @override
  void paint(Canvas canvas, Size size) {
    final data = notifier.value;
    final stroke = data.stroke;
    if (stroke == null || stroke.points.isEmpty) return;
    _applyViewTransform(canvas, size, data.scale, data.panOffset);
    _drawStroke(canvas, stroke.points, stroke.color, stroke.strokeWidth, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ActiveStrokePainter old) => false;
}

// ── Helpers ────────────────────────────────────────────

/// Aplica o transform de zoom/pan.
/// Origem do canvas = centro da tela.
/// 1 unidade = min(w, h) pixels.
void _applyViewTransform(
    Canvas canvas, Size size, double scale, Offset panOffset) {
  final base = min(size.width, size.height);
  canvas.save();
  canvas.translate(size.width / 2, size.height / 2); // origem no centro
  canvas.scale(scale);
  canvas.translate(-panOffset.dx * base, -panOffset.dy * base);
}

/// Converte coord normalizada → pixel relativo à origem (centro do canvas).
/// A centralização já foi feita pelo _applyViewTransform.
void _drawStroke(
  Canvas canvas,
  List<Offset> normPoints,
  Color color,
  double strokeWidth,
  Size size,
) {
  if (normPoints.isEmpty) return;

  final base = min(size.width, size.height);
  Offset px(Offset n) => Offset(n.dx * base, n.dy * base);

  final paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  if (normPoints.length == 1) {
    canvas.drawCircle(px(normPoints.first), strokeWidth / 2, paint);
    return;
  }

  final path = Path()
    ..moveTo(px(normPoints[0]).dx, px(normPoints[0]).dy);

  for (int i = 0; i < normPoints.length - 1; i++) {
    final c = px(normPoints[i]);
    final n = px(normPoints[i + 1]);
    final mid = Offset((c.dx + n.dx) / 2, (c.dy + n.dy) / 2);
    path.quadraticBezierTo(c.dx, c.dy, mid.dx, mid.dy);
  }
  path.lineTo(px(normPoints.last).dx, px(normPoints.last).dy);
  canvas.drawPath(path, paint);
}

// ── Guia por símbolo ───────────────────────────────────

/// Retorna o caminho do asset PNG de guia para o símbolo, ou null se não houver.
String? guideAssetPath(String symbolId) {
  const guides = {
    'choku_rei':      'assets/guides/choku_rei.png',
    'seiheki':        'assets/guides/seiheki.png',
    'honshazeshonen': 'assets/guides/honshazeshonen.png',
    'daikoomyo_usui': 'assets/guides/daikoomyo_usui.png',
    'serpente_fogo':  'assets/guides/serpente_fogo.png',
    'raku':           'assets/guides/raku.png',
    'la_hanna_nai':   'assets/guides/la_hanna_nai.png',
  };
  return guides[symbolId];
}

/// True se o símbolo tem algum guia disponível (vetorial ou PNG).
bool symbolHasGuide(String? symbolId) {
  if (symbolId == null) return false;
  return symbolId == 'choku_rei' || guideAssetPath(symbolId) != null;
}

/// Camada de guia: vetorial para choku_rei, PNG para os demais.
class _SymbolGuideLayer extends StatelessWidget {
  final String? symbolId;
  const _SymbolGuideLayer({this.symbolId});

  @override
  Widget build(BuildContext context) {
    final path = symbolId != null ? guideAssetPath(symbolId!) : null;
    if (path == null) return const SizedBox.shrink();

    return Opacity(
      opacity: 0.50,
      child: Transform.scale(
        scale: 1.2,
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          color: Colors.white,
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}
