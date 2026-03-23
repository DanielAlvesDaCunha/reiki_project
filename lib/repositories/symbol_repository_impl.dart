import '../models/reiki_symbol.dart';
import 'symbol_repository.dart';

class SymbolRepositoryImpl implements SymbolRepository {
  static const _symbols = <ReikiSymbol>[
    ReikiSymbol(
      id: 'choku_rei',
      name: 'Choku Rei',
      subtitle: 'Símbolo do Poder',
      element: 'Terra',
      description:
          'Um dos símbolos mais conhecidos e utilizados no Reiki. Também conhecido como '
          '"Interruptor de Luz". Finalidade principal: aumentar e direcionar a energia. '
          'Utilizado para auto-selamento dos chacras principais antes de qualquer aplicação.',
      origin:
          'Possui origem arquetípica em três culturas distintas: Xintoísmo, Taoísmo e Budismo. '
          'Essa fusão pode ser encontrada no Shugendō, antiga tradição japonesa.',
      actions: [
        'Aumentar o fluxo de energia',
        'Limpar e proteger ambientes',
        'Selamento dos chacras',
        'Acelerar tratamentos',
        'Limpeza energética',
      ],
      minLevel: ReikiLevel.levelI,
    ),
    ReikiSymbol(
      id: 'seiheki',
      name: 'Seiheki',
      subtitle: 'Símbolo da Harmonia',
      element: 'Lua',
      description:
          'Segundo símbolo do Reiki Usui. Harmoniza as energias de diferentes esferas da '
          'existência, unindo o físico (Terra) e o espiritual (Céu). Frequentemente colocado '
          'na entrada de espaços para proteção. Energeticamente dependente do Choku Rei.',
      origin:
          'De origem budista com modificações sofridas através do tempo. Promove equilíbrio '
          'emocional, harmonia e purificação.',
      actions: [
        'Promover equilíbrio emocional',
        'Clareza mental',
        'Tratar casos de vícios',
        'Limpeza e purificação',
        'Ressignificar padrões de desequilíbrio',
      ],
      minLevel: ReikiLevel.levelII,
    ),
    ReikiSymbol(
      id: 'honshazeshonen',
      name: 'Honshazeshonen',
      subtitle: 'Símbolo da Distância',
      element: 'Sol',
      description:
          'Um dos símbolos mais complexos do Reiki Usui. Possibilita ultrapassar as barreiras '
          'físicas ou temporais. Também conhecido como "símbolo do carma". '
          '"O Buda em mim saúda o Buda em você para a iluminação e a paz."',
      origin:
          'Origem mais provável no Budismo. Composto por cinco kanjis: Hon (raiz), Sha (pessoa), '
          'Ze (ser/justo), Sho (correto), Nen (pensamento/intenção).',
      actions: [
        'Reiki a distância',
        'Tratar questões do passado e do futuro',
        'Acessibilidade e flexibilidade',
        'Liberação de energias negativas ancestrais',
        'Reprogramação energética',
      ],
      minLevel: ReikiLevel.levelII,
    ),
    ReikiSymbol(
      id: 'daikoomyo_usui',
      name: 'Daikoomyo Usui',
      subtitle: 'Símbolo Mestre',
      element: 'Céu e Terra',
      description:
          'Quarto e último símbolo principal do Reiki Usui. Representa o caminho espiritual '
          'em direção à Satori (iluminação). Conecta o reikiano à fonte da energia. '
          'Significa "Grande Luz Brilhante".',
      origin:
          'Integração de princípios do Budismo, Xintoísmo e Taoísmo. '
          'Dai (大): Grande. Koo (光): Luz. Myo (明): Brilhante.',
      actions: [
        'Iniciações e sintonizações',
        'Promover equilíbrio espiritual',
        'Fortalecer outros símbolos',
        'Conexão com a Consciência Superior',
        'Retirada de bloqueios energéticos',
      ],
      minLevel: ReikiLevel.levelIIIA,
    ),
    ReikiSymbol(
      id: 'daikoomyo_tibetano',
      name: 'Daikoomyo Tibetano',
      subtitle: 'Símbolo Mestre Tibetano',
      element: 'Espiritual Profundo',
      description:
          'Símbolo mestre no sistema de Reiki Tibetano-Usui. Foca na ativação da energia '
          'interna para alcançar a iluminação. Promove conexões com as energias universais '
          'através do chacra coronário.',
      origin:
          'Representa a "Grande Luz Brilhante" no sistema Tibetano-Usui. '
          'Diferente do Daikoomyo Usui tradicional em forma e aplicação.',
      actions: [
        'Purificação e ativação',
        'Aprimoramento das iniciações',
        'Ação espiritual profunda',
        'Aumento de poder',
      ],
      minLevel: ReikiLevel.levelIIIB,
    ),
    ReikiSymbol(
      id: 'serpente_fogo',
      name: 'Serpente de Fogo',
      subtitle: 'Dumo / Kundalini',
      element: 'Fogo Interior',
      description:
          'Exclusivo para mestres de iniciação (Nível IIIB). Representa o fogo interior. '
          'Unifica os principais chacras, ilumina e eleva a consciência.',
      origin:
          'Origem no Hinduísmo/Yoga. Representa a energia Kundalini — energia vital '
          'adormecida na base da coluna vertebral que sobe pelos chacras quando despertada.',
      actions: [
        'Ativação e purificação dos chacras',
        'Aumento de poder',
        'Tratar traumas',
        'Iniciações de Mestrado',
      ],
      minLevel: ReikiLevel.levelIIIB,
    ),
    ReikiSymbol(
      id: 'raku',
      name: 'Raku Tibetano',
      subtitle: 'Raio da Luz',
      element: 'Aterramento',
      description:
          'Função principal: "separar" ou "aterrar" a energia para promover liberdade, '
          'iluminação e paz. Exclusivo para Mestres no processo de consagração. '
          'Símbolo de finalização e estabilização.',
      origin:
          'Adicionado posteriormente ao sistema de Mikao Usui. '
          '"O que traz o raio da luz."',
      actions: [
        'Aterramento energético',
        'Separação energética',
        'Liberação de energias negativas ancestrais',
      ],
      minLevel: ReikiLevel.levelIIIB,
    ),
    ReikiSymbol(
      id: 'la_hanna_nai',
      name: 'La Hanna Nai',
      subtitle: 'Luz que Ilumina o Caminho',
      element: 'Luz Divina',
      description:
          'Símbolo de mestrado de linhagens modernas do Reiki. '
          'Não precisa de iniciação para ser usado. Representa a conexão com os '
          'Mestres das diferentes linhagens.',
      origin:
          'Não faz parte do sistema original de Mikao Usui. '
          '"Luz que ilumina o caminho."',
      actions: [
        'Purificação de energias ancestrais',
        'Conexão com o Divino',
        'Despertar da consciência',
        'Promover equilíbrio emocional e mental',
      ],
      minLevel: ReikiLevel.levelIIIB,
    ),
  ];

  @override
  List<ReikiSymbol> getAll() => _symbols;

  @override
  ReikiSymbol? getById(String id) {
    try {
      return _symbols.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<ReikiSymbol> getByLevel(ReikiLevel level) =>
      _symbols.where((s) => s.minLevel == level).toList();
}
