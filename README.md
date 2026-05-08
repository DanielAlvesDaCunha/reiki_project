# Conecn't Reiki

Aplicativo Flutter para prática do **Yantra** — o desenho dos símbolos sagrados do Reiki.
Desenvolvido no contexto das Práticas Integrativas e Complementares em Saúde (PICS) da Fiocruz.

---

## Sobre o Aplicativo

O Conecn't Reiki é uma ferramenta de apoio para reikianos devidamente habilitados por um Mestre.
Seu objetivo é auxiliar na prática e memorização dos símbolos sagrados do Reiki através do Yantra (desenho) e do Mantra (vocalização).

> Os símbolos do Reiki são sagrados e compostos pela união de **YANTRA** e **MANTRA**.
> Só possuem efetividade quando utilizados por um reikiano devidamente habilitado em seus respectivos níveis.

---

## Funcionalidades

- **Tela de início** — declaração de ciência, histórico do Reiki, níveis e técnica de Selamento
- **Catálogo de símbolos** — 8 símbolos com descrição, origem, elemento e ações, filtrável por nível
- **Prática do Yantra** — canvas de desenho livre com:
  - Guia de setas numeradas (sequência de traços) no canvas
  - Botão para mostrar/ocultar o guia
  - Zoom e pan com dois dedos
  - Seletor de cor e espessura do traço
  - Desfazer e limpar
- **Selamento do Reiki** — técnica de blindagem energética com os 7 passos detalhados

---

## Símbolos

| Símbolo | Subtítulo | Nível mínimo |
|---|---|---|
| Choku Rei | Símbolo do Poder | Nível I |
| Seiheki | Símbolo da Harmonia | Nível II |
| Honshazeshonen | Símbolo da Distância | Nível II |
| Daikoomyo Usui | Símbolo Mestre | Nível III A |
| Daikoomyo Tibetano | Símbolo Mestre Tibetano | Nível III B |
| Serpente de Fogo | Dumo / Kundalini | Nível III B |
| Raku Tibetano | Raio da Luz | Nível III B |
| La Hanna Nai | Luz que Ilumina o Caminho | Nível III B |

---

## Técnica de Selamento

O Selamento do Reiki é recomendado antes de ministrar qualquer aplicação e pode ser usado diariamente como blindagem energética pessoal (duração: até 24 horas).

1. Respirar (Joshin) em posição de Gasho
2. Elevar o pensamento (Reiji Ho) — conexão com as Energias Universais
3. Ancorar os símbolos do nível pelo chacra coronário
4. Irradiar a energia a partir do coração para todo o corpo
5. Mantrar e Yantrar o Choku Rei em cada palma das mãos
6. Fazer um grande Choku Rei cobrindo todo o ser
7. Yantrar o Choku Rei em cada um dos 7 chacras (do básico ao coronário)

---

## Stack Técnica

| Camada | Tecnologia |
|---|---|
| Framework | Flutter 3.41.1 / Dart 3.7 |
| Arquitetura | MVVM |
| State management | flutter_bloc (BLoC como ViewModel) |
| Injeção de dependência | get_it |
| HTTP (futuro) | dio |
| UI | Material Design 3, tema escuro roxo/dourado |

### Estrutura de pastas

```
lib/
├── core/
│   ├── di/          # GetIt — injeção de dependências
│   ├── network/     # DioClient (preparado para API futura)
│   ├── routes/      # FadeSlideRoute — transições customizadas
│   └── theme/       # AppTheme — tema escuro roxo/dourado
├── models/          # ReikiSymbol, ReikiLevel
├── repositories/    # Interface + implementação local dos símbolos
├── viewmodels/
│   ├── disclaimer/  # BLoC da tela de início
│   ├── symbol/      # BLoC do catálogo (filtro por nível)
│   └── drawing/     # BLoC do canvas (traços, cor, espessura, guia)
└── views/
    ├── pages/       # DisclaimerPage, HomePage, SymbolDetailPage, DrawingPage
    └── widgets/     # SymbolCard, DrawingCanvas, ChokuReiGuide
```

---

## Contexto Regulatório

As Práticas Integrativas e Complementares em Saúde (PICS) são regulamentadas no SUS:

- **Portaria GM/MS nº 971/2006** — regulamenta as PICS no SUS
- **Portaria GM/MS nº 849/2017** — inclui o Reiki oficialmente no SUS

> O Reiki não substitui a medicina tradicional, mas a complementa.

---

## Histórico

- **Mestre iniciador:** Mikao Usui (Japão)
- **Introduzido nas Américas por:** Mestre Hawayo Takata
- **Chegou ao Brasil em 1983**, no Rio de Janeiro, por Egídio Vecchio

---

## Desenvolvimento

Projeto desenvolvido no laboratório da **Fiocruz** como ferramenta complementar de apoio às PICS.
