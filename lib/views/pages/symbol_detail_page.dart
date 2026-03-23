import 'package:flutter/material.dart';

import '../../core/routes/fade_slide_route.dart';
import '../../models/reiki_symbol.dart';
import 'drawing_page.dart';

class SymbolDetailPage extends StatelessWidget {
  final ReikiSymbol symbol;

  const SymbolDetailPage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final hPadding = (w * 0.05).clamp(16.0, 64.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Praticar Yantra',
            onPressed: () => Navigator.of(context).push(
              FadeSlideRoute(page: DrawingPage(symbol: symbol)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SymbolHeader(symbol: symbol),
                const SizedBox(height: 24),
                _Section(
                  icon: Icons.description_outlined,
                  title: 'Descrição',
                  content: symbol.description,
                ),
                const SizedBox(height: 16),
                _Section(
                  icon: Icons.history_edu,
                  title: 'Origem',
                  content: symbol.origin,
                ),
                const SizedBox(height: 16),
                _ActionsList(actions: symbol.actions),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      FadeSlideRoute(page: DrawingPage(symbol: symbol)),
                    ),
                    icon: const Icon(Icons.gesture),
                    label: const Text('Praticar o Yantra'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: (w * 0.04).clamp(14.0, 22.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SymbolHeader extends StatelessWidget {
  final ReikiSymbol symbol;
  const _SymbolHeader({required this.symbol});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final avatarSize = (w * 0.18).clamp(64.0, 120.0);

    return Row(
      children: [
        Hero(
          tag: 'symbol-avatar-${symbol.id}',
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF6A0DAD), Color(0xFF1A0A2E)],
              ),
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x446A0DAD),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: symbol.imagePath != null
                ? ClipOval(
                    child: Image.asset(symbol.imagePath!, fit: BoxFit.cover))
                : Icon(Icons.auto_awesome,
                    color: const Color(0xFFFFD700), size: avatarSize * 0.45),
          ),
        ),
        SizedBox(width: (w * 0.04).clamp(12.0, 28.0)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(symbol.name, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(symbol.subtitle,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: const Color(0xFFFFD700))),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.filter_vintage,
                      size: 14, color: Color(0xFFB388FF)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(symbol.element,
                        style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D2060),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  symbol.minLevel.label,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _Section({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final padding = (w * 0.04).clamp(12.0, 24.0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3D2060)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFFB388FF)),
              const SizedBox(width: 8),
              Text(title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}

class _ActionsList extends StatelessWidget {
  final List<String> actions;
  const _ActionsList({required this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final padding = (w * 0.04).clamp(12.0, 24.0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3D2060)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, size: 18, color: Color(0xFFFFD700)),
              const SizedBox(width: 8),
              Text('Atuações e Ações',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ...actions.map(
            (a) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.fiber_manual_record,
                      size: 8, color: Color(0xFFB388FF)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(a, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
