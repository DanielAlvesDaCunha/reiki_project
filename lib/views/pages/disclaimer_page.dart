import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/disclaimer/disclaimer_event.dart';
import '../../viewmodels/disclaimer/disclaimer_state.dart';
import '../../viewmodels/disclaimer/disclaimer_viewmodel.dart';
import 'home_page.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DisclaimerViewModel, DisclaimerState>(
      listener: (context, state) {
        if (state is DisclaimerAccepted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _DisclaimerContent()),
              _AcceptButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisclaimerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final isTablet = w >= 600;
    final hPadding = (w * 0.06).clamp(20.0, 80.0);
    final iconSize = (w * 0.15).clamp(48.0, 96.0);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          // em tablet limita largura do conteúdo
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            children: [
              Image.asset(
                'assets/images/icon_rounded.png',
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: iconSize * 0.25),
              Text(
                'Conecn\'t',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFFFFD700),
                  letterSpacing: 2,
                  fontSize: isTablet ? 56 : 44,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'O Reiki na palma da sua mão',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1,
                  fontSize: isTablet ? 26 : 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(isTablet ? 28 : 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1B4E),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color(0xFF6A0DAD), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Color(0xFFFFD700), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Declaração de Ciência',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Declaro que estou ciente que os símbolos do Reiki são sagrados e compostos pela união de YANTRA e MANTRA. Estes devem ser tratados com respeito e só possuem efetividade quando utilizados por um reikiano que tenha sido devidamente HABILITADO por um Mestre, em seus respectivos níveis.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'O objetivo da aplicação de Reiki não é substituir a medicina tradicional, mas complementá-la.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'As Práticas Integrativas e Complementares em Saúde (PICS) são regulamentadas no SUS por meio da Portaria GM/MS nº 971/2006. O Reiki foi oficialmente incluído no SUS em 2017 pela Portaria GM/MS nº 849/2017.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _InfoSection(
                title: 'Significado',
                content:
                    'A palavra Reiki é de origem japonesa.\n• Rei = energia universal\n• Ki = energia vital',
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Breve Histórico',
                content: '• Mestre iniciador: Mikao Usui\n'
                    '• Introduzido nas Américas por: Mestre Hawayo Takata\n'
                    '• Chegou ao Brasil em 1983, no Rio de Janeiro, por Egídio Vecchio',
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Níveis do Reiki',
                content: '• Nível I — Shoden: O Despertar\n'
                    '• Nível II — Okuden: A Transformação\n'
                    '• Nível III A — Shinpiden: A Realização\n'
                    '• Nível III B — Gokukaiden: Mestre Professor',
              ),
              const SizedBox(height: 16),
              const _SealingSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final isTablet = w >= 600;
    final innerPad = isTablet ? 20.0 : 14.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(innerPad),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E).withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3D2060)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: (isTablet
                      ? theme.textTheme.titleLarge
                      : theme.textTheme.titleMedium)
                  ?.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: isTablet ? 10 : 8),
          Text(
            content,
            style: isTablet
                ? theme.textTheme.bodyLarge
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SealingSection extends StatelessWidget {
  const _SealingSection();

  static const _steps = [
    (
      icon: Icons.self_improvement,
      text: 'Respirar (Joshin) em posição de Gasho',
    ),
    (
      icon: Icons.connect_without_contact,
      text:
          'Elevar o pensamento (Reiji Ho) — conexão com as Energias Universais',
    ),
    (
      icon: Icons.arrow_downward,
      text:
          'Ancorar os símbolos do seu nível, mentalizando-os adentrando pelo chacra coronário',
    ),
    (
      icon: Icons.favorite,
      text:
          'A partir do coração, a Energia Reiki é disseminada para todo o corpo e sai pelas mãos',
    ),
    (
      icon: Icons.back_hand,
      text:
          'Mantrar e Yantrar o Choku Rei em cada palma das mãos para sensibilizá-las',
    ),
    (
      icon: Icons.shield_outlined,
      text:
          'Fazer um grande Choku Rei à frente, mentalizando cobrindo todo o seu ser',
    ),
    (
      icon: Icons.grain,
      text:
          'Fazer um Choku Rei em cada chacra (do básico ao coronário), yantrando e mantrando, '
              'um de cada vez, mentalizando o símbolo adentrando no local',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final isTablet = w >= 600;
    final innerPad = isTablet ? 20.0 : 14.0;
    final badgeSize = isTablet ? 30.0 : 26.0;
    final iconSize = isTablet ? 18.0 : 16.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(innerPad),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E).withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6A0DAD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined,
                  color: const Color(0xFFFFD700), size: isTablet ? 22 : 18),
              const SizedBox(width: 8),
              Text(
                'Selamento do Reiki',
                style: (isTablet
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium)
                    ?.copyWith(
                  color: const Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 8 : 6),
          Text(
            'Recomendado antes de ministrar o Reiki e como blindagem energética diária. '
            'Duração: até 24 horas.',
            style: (isTablet
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodySmall)
                ?.copyWith(
              color: const Color(0xFFB388FF),
            ),
          ),
          SizedBox(height: isTablet ? 18 : 14),
          ...List.generate(_steps.length, (i) {
            final step = _steps[i];
            return Padding(
              padding: EdgeInsets.only(bottom: isTablet ? 14 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6A0DAD),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: (isTablet
                                ? theme.textTheme.labelMedium
                                : theme.textTheme.labelSmall)
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 10),
                  Icon(step.icon,
                      size: iconSize, color: const Color(0xFFB388FF)),
                  SizedBox(width: isTablet ? 10 : 8),
                  Expanded(
                    child: Text(
                      step.text,
                      style: isTablet
                          ? theme.textTheme.bodyLarge
                          : theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AcceptButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final hPadding = (w * 0.06).clamp(20.0, 80.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(hPadding, 12, hPadding, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context
                  .read<DisclaimerViewModel>()
                  .add(const AcceptDisclaimer()),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                'Declaro estar ciente e aceito os termos',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
