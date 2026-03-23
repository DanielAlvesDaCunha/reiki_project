import 'package:flutter/material.dart';

import '../../models/reiki_symbol.dart';

class SymbolCard extends StatelessWidget {
  final ReikiSymbol symbol;
  final VoidCallback onTap;

  const SymbolCard({super.key, required this.symbol, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final avatarSize = (w * 0.13).clamp(48.0, 80.0);
    final padding = (w * 0.04).clamp(12.0, 24.0);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              Hero(
                tag: 'symbol-avatar-${symbol.id}',
                child: _SymbolAvatar(symbol: symbol, size: avatarSize),
              ),
              SizedBox(width: padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(symbol.name, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(symbol.subtitle, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 14, color: theme.colorScheme.tertiary),
                        const SizedBox(width: 4),
                        Text(
                          symbol.element,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontSize: (w * 0.03).clamp(11.0, 14.0)),
                        ),
                        const SizedBox(width: 12),
                        Chip(
                          label: Text(
                            symbol.minLevel.label.split('—').first.trim(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolAvatar extends StatelessWidget {
  final ReikiSymbol symbol;
  final double size;
  const _SymbolAvatar({required this.symbol, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF6A0DAD), Color(0xFF2D1B4E)],
        ),
        border: Border.all(color: const Color(0xFFB388FF), width: 1.5),
      ),
      child: symbol.imagePath != null
          ? ClipOval(
              child: Image.asset(symbol.imagePath!, fit: BoxFit.cover),
            )
          : Icon(Icons.auto_awesome,
              color: const Color(0xFFB388FF), size: size * 0.5),
    );
  }
}
