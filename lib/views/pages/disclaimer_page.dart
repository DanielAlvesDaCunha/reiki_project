import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/disclaimer/disclaimer_event.dart';
import '../../viewmodels/disclaimer/disclaimer_state.dart';
import '../../viewmodels/disclaimer/disclaimer_viewmodel.dart';
import 'home_page.dart';

class DisclaimerPage extends StatelessWidget {
  /// true quando aberta pela HomePage só para reler o conteúdo
  /// (mostra seta de voltar e esconde o botão de aceite).
  final bool isReview;

  const DisclaimerPage({super.key, this.isReview = false});

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
        appBar: isReview
            ? AppBar(title: const Text('Página Inicial'))
            : null,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: _DisclaimerContent()),
              if (!isReview) _AcceptButton(),
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
              _InfoSection(
                title: 'Objetivo do Aplicativo',
                content:
                    'O aplicativo tem como objetivo principal praticar o traçado dos símbolos de forma correta '
                    'e fornecer informações gerais sobre sua história e aplicação.\n\n'
                    'Para traçar cada símbolo do Reiki corretamente, siga estes passos simples:\n'
                    '• Siga a numeração: passe o dedo sobre as linhas na ordem indicada pelos números.\n'
                    '• Acompanhe as setas: movimente seu dedo na direção exata para onde as setas apontam.',
              ),
              const SizedBox(height: 24),
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
                      'Declaro que estou ciente que os símbolos do Reiki são sagrados e compostos pela união do seu desenho (YANTRA) e da verbalização (MANTRA). Estes devem ser tratados com respeito e só possuem efetividade quando utilizados por um reikiano que tenha sido devidamente HABILITADO por um Mestre, em seus respectivos níveis.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _InfoSection(
                title: 'Objetivo do Reiki',
                content:
                    'A aplicação de Reiki não substitui a medicina tradicional, mas a complementa.\n\n'
                    'As Práticas Integrativas e Complementares em Saúde (PICS) são regulamentadas no Sistema '
                    'Único de Saúde (SUS) por meio de portarias do Ministério da Saúde (MS) que '
                    'institucionalizaram a Política Nacional de Práticas Integrativas e Complementares (PNPIC) '
                    'no ano de 2006, através da Portaria GM/MS nº 971, de 3 de maio de 2006. O Reiki foi '
                    'oficialmente incluído no SUS em 2017 por meio da Portaria GM/MS nº 849/2017.',
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Significado',
                content:
                    'A palavra Reiki é de origem japonesa.\n• Rei = energia universal\n• Ki = energia vital',
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Breve Histórico',
                content: '• O Reiki teve como Mestre iniciador Mikao Usui, em 1922.\n'
                    '• Chujiro Hayashi foi um dos principais discípulos de Mikao Usui, responsável por organizar e disseminar o Reiki.\n'
                    '• Quem trouxe o Reiki para as Américas foi a Mestre Hawayo Takata.\n'
                    '• O Reiki chegou ao Brasil no ano de 1983, no Rio de Janeiro, por Egídio Vecchio, '
                    'com o curso ministrado pelo Mestre americano Stephen Cord Saiki.\n\n'
                    'O Reiki é considerado uma filosofia de vida por grandes Mestres reikianos do mundo, e parte '
                    'dela é oriunda do Imperador Meiji, que foi um revolucionário no Japão e deixou um legado de '
                    'milhares de poemas que serviram de inspiração a Mikao Usui. Entre estas inspirações temos '
                    'os 125 poemas e os cinco princípios do Reiki, considerados como base filosófica.',
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
              _InfoSection(
                title: 'Os Símbolos',
                content:
                    'Os símbolos preferencialmente devem ser Yantrados com a mão dominante.\n\n'
                    '• No Nível I do Reiki o símbolo ancorado é o Sho Ku Rei (opcional: o mestre pode '
                    'habilitar seu aluno neste símbolo neste nível).\n'
                    '• No Nível II do Reiki os símbolos ancorados são: Sho Ku Rei, Sei He Ki e Hon Sha Ze Sho Nen.\n'
                    '• No Nível III A do Reiki o símbolo ancorado é o Dai Koo Myo Usui.\n'
                    '• No Nível III B do Reiki os símbolos ancorados são: Dai Ko Myo Tibetano, Serpente de Fogo '
                    'e, opcionalmente por alguns mestres, o La Hanna Nai e o Raku.',
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Como utilizar a energia do Reiki durante a aplicação',
                content:
                    '• Intenção clara: o reikiano define a intenção de enviar Reiki para o receptor ou '
                    'situação específica.\n'
                    '• Ativação do símbolo: cada símbolo tem sua energia ativada quando Yantrado uma vez e '
                    'Mantrado três vezes. Serve como uma "ponte" energética.\n'
                    '• Visualização: mentalizar a energia Reiki sobre o receptor ou a situação a ser tratada.\n'
                    '• Canalização: a energia Reiki é canalizada através do reikiano e enviada para o '
                    'receptor ou para a situação a ser tratada.\n'
                    '• Autorização prévia, no caso do envio a distância: o receptor deverá autorizar '
                    'previamente a aplicação. No caso de o receptor ser ou estar incapaz, a permissão '
                    'deverá ser dada pelo responsável direto.',
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Gokai — Os Cinco Princípios do Reiki',
                content:
                    'Para o Mestre Mikao Usui, a cura do corpo começa na alma. Por isso, ele uniu a energia '
                    'do Reiki à filosofia do Imperador Meiji (1852–1912), uma figura histórica admirada por sua sabedoria.\n\n'
                    'O imperador escreveu milhares de poemas sagrados (Gyosei) sobre ética e espiritualidade. '
                    'Inspirado por essa profunda sabedoria, Usui escreve o Gokai — os Cinco Princípios do Reiki:\n\n'
                    '• Só por hoje, não sinto raiva.\n'
                    '• Só por hoje, não me preocupo.\n'
                    '• Só por hoje, sou grato.\n'
                    '• Só por hoje, trabalho com honestidade.\n'
                    '• Só por hoje, sou bondoso com todos os seres.\n\n'
                    'Para que serve e como usar?\n\n'
                    'Eles servem como uma bússola diária para a paz interior, limpando a mente e elevando sua vibração.\n\n'
                    'Como usar: recite-os duas vezes ao dia (ao acordar e antes de dormir). Se puder, junte as mãos '
                    'em prece na altura do coração (posição Gassho), respire fundo e sinta a força do momento presente.',
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
      icon: Icons.air,
      text: 'Respirar (Joshin)',
    ),
    (
      icon: Icons.self_improvement,
      text: 'Mãos unidas na frente do coração (Gasho)',
    ),
    (
      icon: Icons.connect_without_contact,
      text:
          'Elevar o pensamento e se conectar com as Energias Universais (Reiji)',
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
          'Mantrar e Yantrar o Sho Ku Rei em cada palma das mãos para sensibilizá-las',
    ),
    (
      icon: Icons.shield_outlined,
      text:
          'Fazer um grande Sho Ku Rei à frente, mentalizando cobrindo todo o seu ser',
    ),
    (
      icon: Icons.grain,
      text:
          'Fazer um Sho Ku Rei em cada chacra (do básico ao coronário), yantrando e mantrando, '
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
                'Selamento (Proteção) do Reiki',
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
