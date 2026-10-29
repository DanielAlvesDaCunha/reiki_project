import '../models/reiki_symbol.dart';
import 'symbol_repository.dart';

class SymbolRepositoryImpl implements SymbolRepository {
  static const _symbols = <ReikiSymbol>[
    ReikiSymbol(
      id: 'choku_rei',
      name: 'Sho Ku Rei',
      subtitle: 'Símbolo do Poder',
      element: 'Terra',
      description:
          'Liga-se à energia do Planeta Terra.\n\n'
          'É um dos símbolos mais conhecidos e utilizados, sendo ensinado no nível II, contudo '
          'alguns mestres ensinam desde o nível I de Reiki.\n\n'
          'Promove equilíbrio energético e proteção. Também conhecido como "Símbolo do Poder" '
          'e "Interruptor de Luz".\n\n'
          'Finalidade principal: aumentar e direcionar a energia.\n\n'
          'Utilizado pelos reikianos para o auto-selamento (proteção) dos chacras principais. '
          'Esse selamento pode ser realizado na sua rotina, porém é recomendável a sua utilização '
          'antes de qualquer tipo de aplicação.',
      origin:
          'Muito provavelmente tem origem arquetípica em três culturas distintas, pois apresenta '
          'elementos do Xintoísmo, Taoísmo e Budismo.\n\n'
          'Essa fusão de conceitos pode ser encontrada no Shugendō, antiga tradição japonesa que '
          'combina elementos das três filosofias para alcançar a iluminação.',
      actionsIntro:
          'Atua na parte física (pessoas, animais, plantas e objetos) e pode ser usado para:',
      actions: [
        'Aumentar o fluxo de energia',
        'Limpar e proteger ambientes',
        'Selamento (Proteção)',
        'Acelerador de tratamento',
        'Limpeza energética',
      ],
      minLevel: ReikiLevel.levelI,
    ),
    ReikiSymbol(
      id: 'seiheki',
      name: 'Sei He Ki',
      subtitle: 'Símbolo da Harmonia',
      element: 'Lua',
      description:
          'Ligado à energia da Lua.\n\n'
          'É o segundo símbolo do Reiki Usui. É ensinado no nível II.\n\n'
          'Sua função é harmonizar as energias de diferentes esferas da existência, unindo o '
          'físico (Terra) e o espiritual (Céu). Frequentemente chamado de "símbolo da harmonia" '
          'ou "símbolo emocional e mental".\n\n'
          'Usualmente colocado na entrada de espaços para a sua proteção.',
      origin:
          'De origem budista com modificações sofridas através do tempo.\n\n'
          'Promove o equilíbrio emocional, harmonia e purificação, alinhando-se com o princípio '
          'da compaixão.\n\n'
          'Energeticamente dependente do Sho Ku Rei para sua ativação. É um lembrete de que a '
          'saúde não é apenas uma questão física, mas também um estado de equilíbrio emocional e '
          'mental. Usá-lo na prática do Reiki pode trazer bem-estar.\n\n'
          'Pode ter significados como: "a paz está aqui", "o homem e Deus se tornam um". Estes '
          'significados reforçam a ideia de que o símbolo auxilia na união do indivíduo com a '
          'energia universal, promovendo saúde holística e uma elevação da consciência.\n\n'
          'Eles são representações físicas de um poder ou de uma intenção que protege, purifica '
          'e harmoniza um espaço, uma pessoa ou uma comunidade.',
      actionsTitle: 'Atuações e ações do Sei He Ki',
      actionsIntro:
          'Atua nos níveis emocional e mental. Suas principais ações são:',
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
      name: 'Hon Sha Ze Sho Nen',
      subtitle: 'Símbolo da Distância',
      element: 'Sol',
      description:
          'Liga-se à energia do Sol.\n\n'
          'É considerado um dos símbolos mais complexos do Reiki Usui, sendo ensinado no nível II.\n\n'
          'Possibilita ultrapassar as barreiras físicas ou temporais.\n\n'
          'Também conhecido como "símbolo da distância" ou "símbolo do carma".',
      origin:
          'Sua origem mais provável é no Budismo.\n\n'
          'Seu nome, quando traduzido, tem um significado profundo: "O Buda em mim saúda o Buda '
          'em você para a iluminação e a paz". Os kanjis desta palavra têm origem chinesa, mas no '
          'Japão sofreram algumas modificações.\n\n'
          'É uma frase composta por cinco ideogramas (kanjis), cada um com um significado '
          'específico. Ao contrário dos outros símbolos do Reiki, que têm nomes com traduções mais '
          'literais, o Hon Sha Ze Sho Nen é uma frase que encapsula diversas ideias, por isso a sua '
          'complexidade.\n\n'
          'A combinação desses kanjis conota os significados: "A raiz do ser é a intenção correta" '
          'ou "Nem o passado, o presente ou o futuro existem". Portanto, a energia Reiki pode ser '
          'enviada para qualquer ponto no tempo ou espaço.',
      actionsTitle: 'Atuações e ações do Hon Sha Ze Sho Nen',
      actions: [
        'Reiki a distância',
        'Tratar questões do passado e do futuro',
      ],
      extraSections: [
        (
          title: 'Benefícios do Reiki à Distância',
          content: '•  Acessibilidade e flexibilidade\n'
              '•  Liberação de energias negativas de origem ancestral',
        ),
        (
          title: 'Como fazer um tratamento de reprogramação com o Hon Sha Ze Sho Nen?',
          content:
              'Para aplicar o símbolo Hon Sha Ze Sho Nen em um tratamento de reprogramação, ou envio '
              'a distância de Reiki, siga os passos semelhantes ao descrito pelo Sei He Ki, contudo '
              'deve-se usar em ordem decrescente: Hon Sha Ze Sho Nen, Sei He Ki e o Sho Ku Rei.',
        ),
      ],
      minLevel: ReikiLevel.levelII,
    ),
    ReikiSymbol(
      id: 'daikoomyo_usui',
      name: 'Dai Koo Myo Usui',
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
      name: 'Dai Ko Myo Tibetano',
      subtitle: 'Símbolo Mestre Tibetano',
      element: 'Espiritual Profundo',
      description:
          'É o símbolo mestre no sistema de Reiki Tibetano-Usui. Ele é diferente do Dai Koo Myo '
          'do sistema Usui tradicional, tanto em sua forma quanto em sua aplicação.\n\n'
          'Foca na ativação da energia interna para alcançar a iluminação e é utilizado na '
          'consagração de reikianos.\n\n'
          'Promove conexões com as energias universais, estabelecendo ligações com os corpos mais '
          'sutis, através do chacra coronário.',
      origin: 'Representa a "Grande Luz Brilhante".',
      actionsTitle: 'Atuações e ações do Dai Ko Myo Tibetano',
      actions: [
        'Purificação e ativação',
        'Aprimoramento das iniciações',
        'Promove uma ação espiritual profunda',
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
          'É conhecido como Dumo ou Kundalini, é exclusivo para mestres de iniciação (Nível IIIB) '
          'e representa uma energia de purificação e força.\n\n'
          'Representa o fogo interior. Unifica os principais chacras, ilumina e eleva a '
          'consciência, abrindo o caminho para um nível mais profundo de bem-estar e evolução '
          'espiritual.',
      origin:
          'Símbolo não utilizado pelo método de Reiki Usui na sua origem, tendo sido acrescentado '
          'posteriormente. Indícios apontam para origem no Hinduísmo/Yoga, como representação da '
          'energia Kundalini.\n\n'
          'É a representação da energia vital adormecida na base da coluna vertebral, conhecida '
          'como Kundalini nas tradições espirituais indianas. Quando essa energia é despertada, '
          'ela sobe através dos chacras (centros de energia), purificando e ativando cada um '
          'deles. Simboliza uma serpente em espiral.',
      actionsTitle: 'Atuações e ações da Serpente de Fogo',
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
          'Tem a função principal de "separar" ou "aterrar" a energia com intuito de promover a '
          'liberdade, iluminação e paz. É exclusivo para uso de Mestre no processo de consagração '
          'de novos reikianos, em alguns sistemas de Reiki.\n\n'
          'O Raku é um símbolo de finalização e estabilização. Ele assegura que a energia ativada '
          'permaneça no corpo do receptor e que o processo de sintonização com essa energia seja '
          'ancorado.',
      origin:
          'É um símbolo que foi adicionado posteriormente ao sistema original de Mikao Usui, sendo '
          'usado por Mestres (Nível IIIB).\n\n'
          'O nome "Raku" é de origem japonesa, mas sua forma e função parecem ter sido '
          'influenciadas por conceitos de outras tradições, especialmente o Budismo. Seu nome pode '
          'ser traduzido como "o que traz o raio da luz".',
      actionsTitle: 'Atuações e ações do Raku',
      actions: [
        'Aterramento',
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
          'É considerado um símbolo de mestrado e pertence a algumas linhagens mais modernas do '
          'Reiki. Este símbolo não precisa de iniciação para ser usado.',
      origin:
          'É um símbolo de Reiki que não faz parte do sistema original de Mikao Usui. Pode ser '
          'traduzido de forma simples como "luz que ilumina o caminho". Ele representa a conexão '
          'com os Mestres das diferentes linhagens de Reiki, com a luz da iluminação e a '
          'capacidade de encontrar o caminho espiritual.',
      actionsTitle: 'Atuações e ações do La Hanna Nai',
      actions: [
        'Purificação de energias ancestrais',
        'Conexão com o Divino',
        'Despertar da consciência',
        'Promove equilíbrio emocional e mental',
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
