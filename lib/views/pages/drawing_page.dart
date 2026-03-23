import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/reiki_symbol.dart';
import '../../viewmodels/drawing/drawing_event.dart';
import '../../viewmodels/drawing/drawing_state.dart';
import '../../viewmodels/drawing/drawing_viewmodel.dart';
import '../widgets/drawing_canvas.dart';

class DrawingPage extends StatelessWidget {
  final ReikiSymbol symbol;

  const DrawingPage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawingViewModel(),
      child: _DrawingView(symbol: symbol),
    );
  }
}

class _DrawingView extends StatefulWidget {
  final ReikiSymbol symbol;
  const _DrawingView({required this.symbol});

  @override
  State<_DrawingView> createState() => _DrawingViewState();
}

class _DrawingViewState extends State<_DrawingView> {
  bool _immersive = false;

  static const _colors = [
    Color(0xFFB388FF),
    Color(0xFFFFD700),
    Color(0xFF80DEEA),
    Color(0xFFA5D6A7),
    Color(0xFFFF8A65),
    Colors.white,
  ];

  void _enterImmersive() => setState(() => _immersive = true);
  void _exitImmersive() => setState(() => _immersive = false);

  @override
  Widget build(BuildContext context) {
    // shortestSide = menor dimensão independente de orientação
    // phone em landscape tem shortestSide ~393px, tablet tem ~600px+
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return OrientationBuilder(
      builder: (context, orientation) {
        if (isTablet) {
          return _PortraitScaffold(
            symbol: widget.symbol,
            colors: _colors,
            body: _TabletLayout(symbol: widget.symbol, colors: _colors),
            onEnterImmersive: null,
          );
        }

        final isLandscape = orientation == Orientation.landscape || _immersive;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: isLandscape
              ? _LandscapeScaffold(
                  key: const ValueKey('landscape'),
                  symbol: widget.symbol,
                  colors: _colors,
                  onExitImmersive:
                      _immersive && orientation != Orientation.landscape
                          ? _exitImmersive
                          : null,
                )
              : _PortraitScaffold(
                  key: const ValueKey('portrait'),
                  symbol: widget.symbol,
                  colors: _colors,
                  body: _PhoneLayout(symbol: widget.symbol, colors: _colors),
                  onEnterImmersive: _enterImmersive,
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Scaffold portrait — AppBar normal + body variável
// ─────────────────────────────────────────────────────────

class _PortraitScaffold extends StatelessWidget {
  final ReikiSymbol symbol;
  final List<Color> colors;
  final Widget body;
  final VoidCallback? onEnterImmersive;

  const _PortraitScaffold({
    super.key,
    required this.symbol,
    required this.colors,
    required this.body,
    required this.onEnterImmersive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Hero(
            tag: 'symbol-avatar-${symbol.id}',
            child: _SymbolBadge(symbol: symbol, size: 36),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(symbol.name, style: theme.textTheme.titleLarge),
            Text('Yantra — Prática do Desenho',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
          ],
        ),
        actions: [
          BlocBuilder<DrawingViewModel, DrawingState>(
            builder: (ctx, state) => Row(
              children: [
                if (onEnterImmersive != null)
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    tooltip: 'Modo canvas cheio',
                    onPressed: onEnterImmersive,
                  ),
                IconButton(
                  icon: const Icon(Icons.undo),
                  tooltip: 'Desfazer',
                  onPressed: state.strokes.isEmpty
                      ? null
                      : () => ctx
                          .read<DrawingViewModel>()
                          .add(const DrawingUndo()),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Limpar',
                  onPressed: state.isEmpty
                      ? null
                      : () => _confirmClear(ctx),
                ),
              ],
            ),
          ),
        ],
      ),
      body: body,
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar desenho'),
        content: const Text('Deseja apagar todo o Yantra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DrawingViewModel>().add(const DrawingClear());
              Navigator.pop(ctx);
            },
            child: const Text('Limpar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Scaffold landscape — sem AppBar, canvas cheio + hamburguer
// ─────────────────────────────────────────────────────────

class _LandscapeScaffold extends StatefulWidget {
  final ReikiSymbol symbol;
  final List<Color> colors;
  // Se não null → foi ativado pelo botão; voltar sai do imersivo, não da página
  final VoidCallback? onExitImmersive;

  const _LandscapeScaffold({
    super.key,
    required this.symbol,
    required this.colors,
    this.onExitImmersive,
  });

  @override
  State<_LandscapeScaffold> createState() => _LandscapeScaffoldState();
}

class _LandscapeScaffoldState extends State<_LandscapeScaffold>
    with SingleTickerProviderStateMixin {
  bool _panelOpen = false;
  late final AnimationController _ctrl;
  late final Animation<Offset> _slideAnim;
  final _scaleNotifier = ValueNotifier<double>(1.0);
  final _resetTrigger = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    // esconde status/nav bar em landscape para canvas cheio
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    // restaura a UI ao sair
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _ctrl.dispose();
    _scaleNotifier.dispose();
    _resetTrigger.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() => _panelOpen = !_panelOpen);
    _panelOpen ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).shortestSide;
    final gap = (sh * 0.02).clamp(6.0, 10.0);
    final pos = (sh * 0.02).clamp(6.0, 10.0);
    final badgeSize = (sh * 0.09).clamp(28.0, 42.0);
    final panelW = (sh * 0.20).clamp(60.0, 92.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0520),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Canvas ocupa tudo ──
            DrawingCanvas(
              symbolName: widget.symbol.name,
              symbolId: widget.symbol.id,
              scaleNotifier: _scaleNotifier,
              resetTrigger: _resetTrigger,
            ),

            // ── Overlay superior: voltar + nome ──
            Positioned(
              top: pos,
              left: pos,
              child: Row(
                children: [
                  _FloatingIconButton(
                    icon: widget.onExitImmersive != null
                        ? Icons.fullscreen_exit
                        : Icons.arrow_back,
                    onTap: widget.onExitImmersive != null
                        ? widget.onExitImmersive!
                        : () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: gap),
                  Hero(
                    tag: 'symbol-avatar-${widget.symbol.id}',
                    child: _SymbolBadge(symbol: widget.symbol, size: badgeSize),
                  ),
                  SizedBox(width: gap),
                  ValueListenableBuilder<double>(
                    valueListenable: _scaleNotifier,
                    builder: (_, scale, _) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _FloatingLabel(widget.symbol.name),
                        if (scale != 1.0) ...[
                          SizedBox(width: gap),
                          _ZoomResetButton(
                            scale: scale,
                            onTap: () => _resetTrigger.value++,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Botões undo + clear (sempre visíveis, canto inferior esquerdo) ──
            Positioned(
              bottom: pos * 1.2,
              left: pos,
              child: BlocBuilder<DrawingViewModel, DrawingState>(
                builder: (ctx, state) => Row(
                  children: [
                    _FloatingIconButton(
                      icon: Icons.undo,
                      onTap: state.strokes.isEmpty
                          ? null
                          : () => ctx
                              .read<DrawingViewModel>()
                              .add(const DrawingUndo()),
                    ),
                    SizedBox(width: gap),
                    _FloatingIconButton(
                      icon: Icons.delete_outline,
                      color: Colors.redAccent,
                      onTap: state.isEmpty ? null : () => _confirmClear(context),
                    ),
                  ],
                ),
              ),
            ),

            // ── Backdrop animado (escurece canvas ao abrir painel) ──
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: panelW,
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, child) => IgnorePointer(
                  ignoring: _ctrl.value < 0.01,
                  child: Opacity(
                    opacity: _ctrl.value * 0.45,
                    child: child,
                  ),
                ),
                child: GestureDetector(
                  onTap: _togglePanel,
                  behavior: HitTestBehavior.opaque,
                  child: const ColoredBox(
                    color: Colors.black,
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),

            // ── Botão hamburguer ──
            Positioned(
              top: pos,
              right: pos,
              child: _FloatingIconButton(
                icon: _panelOpen ? Icons.close : Icons.tune,
                onTap: _togglePanel,
              ),
            ),

            // ── Painel lateral deslizante ──
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: SlideTransition(
                position: _slideAnim,
                child: _LandscapePanel(colors: widget.colors, symbolId: widget.symbol.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar desenho'),
        content: const Text('Deseja apagar todo o Yantra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<DrawingViewModel>().add(const DrawingClear());
              Navigator.pop(ctx);
            },
            child: const Text('Limpar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Painel lateral landscape
// ─────────────────────────────────────────────────────────

class _LandscapePanel extends StatelessWidget {
  final List<Color> colors;
  final String? symbolId;

  const _LandscapePanel({required this.colors, this.symbolId});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).shortestSide;
    final panelW = (sh * 0.20).clamp(60.0, 92.0);
    final headerSpace = (sh * 0.14).clamp(40.0, 58.0);
    final iconSz = (sh * 0.04).clamp(12.0, 18.0);
    final labelSz = (sh * 0.032).clamp(10.0, 14.0);
    final dotSize = (sh * 0.07).clamp(22.0, 36.0);

    return BlocBuilder<DrawingViewModel, DrawingState>(
      builder: (context, state) {
        return Container(
          width: panelW,
          decoration: const BoxDecoration(
            color: Color(0xEE1A0A2E),
            border: Border(left: BorderSide(color: Color(0xFF3D2060))),
          ),
          child: Column(
            children: [
              SizedBox(height: headerSpace),
              const Divider(color: Color(0xFF3D2060), height: 1),
              SizedBox(height: sh * 0.025),

              // ── Espessura (slider vertical) ──
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Icon(Icons.line_weight,
                        size: iconSz, color: const Color(0xFFB388FF)),
                    SizedBox(height: sh * 0.01),
                    Text(
                      '${state.strokeWidth.toInt()}',
                      style: TextStyle(
                          fontSize: labelSz, color: const Color(0xFFB388FF)),
                    ),
                    Expanded(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          value: state.strokeWidth,
                          min: 2,
                          max: 20,
                          divisions: 9,
                          activeColor: state.selectedColor,
                          onChanged: (v) => context
                              .read<DrawingViewModel>()
                              .add(DrawingStrokeWidthChanged(v)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF3D2060), height: 1),
              SizedBox(height: sh * 0.02),

              // ── Cores ──
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: colors.map((c) {
                      final selected = state.selectedColor == c;
                      final size = selected ? dotSize * 1.15 : dotSize;
                      return Padding(
                        padding: EdgeInsets.only(bottom: sh * 0.02),
                        child: GestureDetector(
                          onTap: () => context
                              .read<DrawingViewModel>()
                              .add(DrawingColorChanged(c)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                          color: c.withAlpha(160),
                                          blurRadius: 6)
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Botão guia (só para choku_rei) ──
              if (symbolId == 'choku_rei') ...[
                const Divider(color: Color(0xFF3D2060), height: 1),
                SizedBox(height: sh * 0.02),
                GestureDetector(
                  onTap: () => context
                      .read<DrawingViewModel>()
                      .add(const DrawingGuideToggled()),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state.showGuide
                          ? const Color(0xFF6A0DAD)
                          : const Color(0xFF2D1B4E),
                      border: Border.all(
                        color: const Color(0xFFFFD700),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.route,
                      size: dotSize * 0.50,
                      color: state.showGuide
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF6A0DAD),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.01),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Layout phone portrait
// ─────────────────────────────────────────────────────────

class _PhoneLayout extends StatelessWidget {
  final ReikiSymbol symbol;
  final List<Color> colors;
  const _PhoneLayout({required this.symbol, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              const ColoredBox(
                color: Color(0xFF0D0520),
                child: SizedBox.expand(),
              ),
              DrawingCanvas(symbolName: symbol.name, symbolId: symbol.id),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween(
                      begin: const Offset(0, 1), end: Offset.zero),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (_, offset, child) =>
                      FractionalTranslation(translation: offset, child: child),
                  child: _DrawingToolbar(colors: colors),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Layout tablet
// ─────────────────────────────────────────────────────────

class _TabletLayout extends StatelessWidget {
  final ReikiSymbol symbol;
  final List<Color> colors;
  const _TabletLayout({required this.symbol, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              const ColoredBox(
                color: Color(0xFF0D0520),
                child: SizedBox.expand(),
              ),
              DrawingCanvas(symbolName: symbol.name, symbolId: symbol.id),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _DrawingToolbar(colors: colors, symbolId: symbol.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────

class _SymbolBadge extends StatelessWidget {
  final ReikiSymbol symbol;
  final double size;
  const _SymbolBadge({required this.symbol, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF6A0DAD), Color(0xFF1A0A2E)],
        ),
        border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
      ),
      child: symbol.imagePath != null
          ? ClipOval(
              child: Image.asset(symbol.imagePath!, fit: BoxFit.cover))
          : Icon(Icons.auto_awesome,
              color: const Color(0xFFFFD700), size: size * 0.5),
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  const _FloatingIconButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).shortestSide;
    final iconSz = (sh * 0.055).clamp(16.0, 24.0);
    final pad = (sh * 0.022).clamp(6.0, 10.0);
    final radius = (sh * 0.028).clamp(8.0, 13.0);
    final iconColor = onTap == null
        ? const Color(0x44B388FF)
        : (color ?? const Color(0xFFB388FF));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: const Color(0x992D1B4E),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0x663D2060)),
        ),
        child: Icon(icon, color: iconColor, size: iconSz),
      ),
    );
  }
}

class _FloatingLabel extends StatelessWidget {
  final String text;
  const _FloatingLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).shortestSide;
    final hPad = (sh * 0.028).clamp(8.0, 13.0);
    final vPad = (sh * 0.016).clamp(5.0, 8.0);
    final radius = (sh * 0.028).clamp(8.0, 13.0);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: const Color(0x992D1B4E),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0x663D2060)),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ZoomResetButton extends StatelessWidget {
  final double scale;
  final VoidCallback onTap;
  const _ZoomResetButton({required this.scale, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).shortestSide;
    final pad = (sh * 0.022).clamp(6.0, 10.0);
    final radius = (sh * 0.028).clamp(8.0, 13.0);
    final iconSz = (sh * 0.055).clamp(16.0, 24.0);
    final fontSize = (sh * 0.032).clamp(10.0, 13.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pad, vertical: pad * 0.7),
        decoration: BoxDecoration(
          color: const Color(0x992D1B4E),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0x663D2060)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(scale * 100).toInt()}%',
              style: TextStyle(
                color: const Color(0xFFB388FF),
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: pad * 0.5),
            Icon(Icons.zoom_out_map, color: const Color(0xFFB388FF), size: iconSz),
          ],
        ),
      ),
    );
  }
}


class _DrawingToolbar extends StatelessWidget {
  final List<Color> colors;
  final String? symbolId;
  const _DrawingToolbar({required this.colors, this.symbolId});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final sh = MediaQuery.sizeOf(context).shortestSide;
    final dotSize = (sh * 0.065).clamp(24.0, 44.0);
    final iconSz = (sh * 0.042).clamp(14.0, 20.0);
    final labelW = (sh * 0.075).clamp(26.0, 36.0);
    final vPad = (sh * 0.025).clamp(8.0, 14.0);

    return BlocBuilder<DrawingViewModel, DrawingState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: (w * 0.04).clamp(12.0, 24.0),
            vertical: vPad,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF2D1B4E),
            border: Border(top: BorderSide(color: Color(0xFF3D2060))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.line_weight,
                      size: iconSz, color: const Color(0xFFB388FF)),
                  Expanded(
                    child: Slider(
                      value: state.strokeWidth,
                      min: 2,
                      max: 20,
                      divisions: 9,
                      activeColor: state.selectedColor,
                      onChanged: (v) => context
                          .read<DrawingViewModel>()
                          .add(DrawingStrokeWidthChanged(v)),
                    ),
                  ),
                  SizedBox(
                    width: labelW,
                    child: Text(
                      state.strokeWidth.toInt().toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...colors.map((c) {
                    final selected = state.selectedColor == c;
                    final size = selected ? dotSize * 1.25 : dotSize;
                    return GestureDetector(
                      onTap: () => context
                          .read<DrawingViewModel>()
                          .add(DrawingColorChanged(c)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? Colors.white : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: selected
                              ? [BoxShadow(color: c.withAlpha(128), blurRadius: 8)]
                              : null,
                        ),
                      ),
                    );
                  }),
                  if (symbolId == 'choku_rei')
                    GestureDetector(
                      onTap: () => context
                          .read<DrawingViewModel>()
                          .add(const DrawingGuideToggled()),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: state.showGuide
                              ? const Color(0xFF6A0DAD)
                              : const Color(0xFF2D1B4E),
                          border: Border.all(
                            color: const Color(0xFFFFD700),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.route,
                          size: dotSize * 0.50,
                          color: state.showGuide
                              ? const Color(0xFFFFD700)
                              : const Color(0xFF6A0DAD),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
