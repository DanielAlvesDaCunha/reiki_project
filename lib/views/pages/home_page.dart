import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/routes/fade_slide_route.dart';
import '../../models/reiki_symbol.dart';
import '../../viewmodels/symbol/symbol_event.dart';
import '../../viewmodels/symbol/symbol_state.dart';
import '../../viewmodels/symbol/symbol_viewmodel.dart';
import '../widgets/symbol_card.dart';
import 'symbol_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Símbolos de Reiki'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAbout(context),
          ),
        ],
      ),
      body: BlocBuilder<SymbolViewModel, SymbolState>(
        builder: (context, state) {
          if (state is SymbolInitial) {
            context.read<SymbolViewModel>().add(const LoadSymbols());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SymbolLoaded) {
            return Column(
              children: [
                _LevelFilter(activeFilter: state.activeFilter),
                Expanded(child: _SymbolList(state: state)),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Text(
          'Conecn\'t Reiki\n\n'
          'Aplicativo para prática do Yantra — o desenho dos símbolos sagrados do Reiki.\n\n'
          'Desenvolvido como ferramenta complementar para reikianos devidamente habilitados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class _SymbolList extends StatefulWidget {
  final SymbolLoaded state;
  const _SymbolList({required this.state});

  @override
  State<_SymbolList> createState() => _SymbolListState();
}

class _SymbolListState extends State<_SymbolList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: 300 + widget.state.filtered.length * 60),
    )..forward();
  }

  @override
  void didUpdateWidget(_SymbolList old) {
    super.didUpdateWidget(old);
    if (old.state.filtered != widget.state.filtered) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _animated(int i, Widget child) {
    final total = widget.state.filtered.length;
    final start = (i / (total + 1) * 0.5).clamp(0.0, 0.7);
    final anim = CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
                begin: const Offset(0, 0.18), end: Offset.zero)
            .animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final isTablet = size.shortestSide >= 600;
    final hPadding = (w * 0.04).clamp(12.0, 32.0);
    final items = widget.state.filtered;

    if (isTablet) {
      return GridView.builder(
        padding: EdgeInsets.fromLTRB(hPadding, 8, hPadding, 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: w >= 900 ? 3 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.6,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) => _animated(
          i,
          SymbolCard(
            symbol: items[i],
            onTap: () => Navigator.of(ctx).push(
              FadeSlideRoute(page: SymbolDetailPage(symbol: items[i])),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(hPadding, 8, hPadding, 24),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _animated(
        i,
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SymbolCard(
            symbol: items[i],
            onTap: () => Navigator.of(ctx).push(
              FadeSlideRoute(page: SymbolDetailPage(symbol: items[i])),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelFilter extends StatelessWidget {
  final ReikiLevel? activeFilter;
  const _LevelFilter({this.activeFilter});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final filterHeight = (w * 0.13).clamp(48.0, 64.0);

    const levels = [
      null,
      ReikiLevel.levelI,
      ReikiLevel.levelII,
      ReikiLevel.levelIIIA,
      ReikiLevel.levelIIIB,
    ];
    final labels = ['Todos', 'Nível I', 'Nível II', 'III A', 'III B'];

    return SizedBox(
      height: filterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: (w * 0.04).clamp(12.0, 32.0),
          vertical: filterHeight * 0.15,
        ),
        itemCount: levels.length,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final isActive = activeFilter == levels[i];
          return FilterChip(
            label: Text(labels[i]),
            selected: isActive,
            onSelected: (_) =>
                ctx.read<SymbolViewModel>().add(FilterByLevel(levels[i])),
            selectedColor: const Color(0xFF6A0DAD),
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isActive ? Colors.white : const Color(0xFFB388FF),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}
