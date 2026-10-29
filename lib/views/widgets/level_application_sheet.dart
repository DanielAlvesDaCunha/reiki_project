import 'package:flutter/material.dart';

import '../../models/reiki_symbol.dart';

/// Conteúdo de "Aplicação" de cada nível: símbolos usados (na ordem de
/// yantrar/mantrar) e as técnicas liberadas a partir daquele nível.
class _LevelApplication {
  final String title;
  final String symbols;
  final List<String> items;
  final List<({String title, List<String> items})> extras;

  const _LevelApplication({
    required this.title,
    required this.symbols,
    this.items = const [],
    this.extras = const [],
  });
}

const _applications = {
  ReikiLevel.levelI: _LevelApplication(
    title: 'Nível I',
    symbols: 'Sho Ku Rei',
    items: [
      'Presencialmente — autoaplicação, aplicação em terceiros, animais, plantas e objetos. '
          'Podemos seguir as 14 posições tradicionais como referência.',
    ],
  ),
  ReikiLevel.levelII: _LevelApplication(
    title: 'Nível II',
    symbols: 'Sho Ku Rei, Sei He Ki e Hon Sha Ze Sho Nen',
    items: [
      'Presencial e a distância. A ordem de ativação é Hon Sha Ze Sho Nen, Sei He Ki e Sho Ku Rei.',
    ],
    extras: [
      (
        title: 'Temos as seguintes técnicas:',
        items: [
          'Envio a distância',
          'Técnica da redução',
          'Técnica do substituto',
          'Técnica da caixinha e do caderno',
        ],
      ),
    ],
  ),
  ReikiLevel.levelIIIA: _LevelApplication(
    title: 'Nível III A',
    symbols: 'Dai Koo Myo Usui + Hon Sha Ze Sho Nen + Sei He Ki + Sho Ku Rei',
    items: [
      'Grandes dimensões (países, empresas, multidões, planeta, entre outros)',
      'Na mandala de cristal',
      'Ativação do canal de força (amplia o canal de passagem de energia): '
          'Dai Koo Myo Usui + Sho Ku Rei + Hon Sha Ze Sho Nen + Sei He Ki',
    ],
    extras: [
      (
        title: 'Como a Cirurgia Espiritual no Reiki funciona',
        items: [
          'Retirada de bloqueios energéticos: visualização mental da remoção de energias negativas '
              'estagnadas, miasmas ou bloqueios a partir de projeções energéticas emanadas das pontas '
              'dos dedos do reikiano, seguida do preenchimento da área com a energia Reiki.',
        ],
      ),
    ],
  ),
  ReikiLevel.levelIIIB: _LevelApplication(
    title: 'Nível III B',
    symbols: 'La Hanna Nai e Raku (opcionalmente); Serpente de Fogo; Dai Ko Myo Tibetano; '
        'Dai Koo Myo Usui; Hon Sha Ze Sho Nen; Sei He Ki e Sho Ku Rei',
    items: [
      'A metodologia de consagração varia de acordo com o nível da iniciação.',
    ],
  ),
};

/// Botão "Aplicação do nível" exibido quando um nível está filtrado.
class LevelApplicationButton extends StatelessWidget {
  final ReikiLevel level;
  const LevelApplicationButton({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final hPadding = (w * 0.04).clamp(12.0, 32.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPadding, 0, hPadding, 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: Text('Aplicação — ${level.label}'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFFD700),
            side: const BorderSide(color: Color(0xFFFFD700)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () => showLevelApplication(context, level),
        ),
      ),
    );
  }
}

void showLevelApplication(BuildContext context, ReikiLevel level) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1A0A2E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) =>
          _ApplicationContent(level: level, controller: controller),
    ),
  );
}

class _ApplicationContent extends StatelessWidget {
  final ReikiLevel level;
  final ScrollController controller;
  const _ApplicationContent({required this.level, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final app = _applications[level]!;
    final body = isTablet ? theme.textTheme.bodyLarge : theme.textTheme.bodyMedium;
    const gold = Color(0xFFFFD700);

    Widget bullets(List<String> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•  ', style: body?.copyWith(color: gold)),
                    Expanded(child: Text(item, style: body)),
                  ],
                ),
              ),
          ],
        );

    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(20, 12, 20, isTablet ? 40 : 28),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Aplicação — ${level.label}',
            style: theme.textTheme.titleLarge
                ?.copyWith(color: gold, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Diferentes técnicas aplicadas ao Reiki neste nível. Todos os símbolos devem ser '
          'Yantrados uma vez e Mantrados três vezes, na ordem indicada abaixo:',
          style: body?.copyWith(color: const Color(0xFFB388FF)),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2D1B4E).withAlpha(128),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6A0DAD)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(app.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: gold, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(app.symbols,
                  style: body?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              bullets(app.items),
              for (final extra in app.extras) ...[
                const SizedBox(height: 8),
                Text(extra.title,
                    style: body?.copyWith(
                        color: gold, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                bullets(extra.items),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Observação: ao mudar de nível, o reikiano passa a poder usar tanto os símbolos '
          'recém-adquiridos como os anteriores, aplicando-os às técnicas do Reiki.',
          style: body?.copyWith(
              color: Colors.white70, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
