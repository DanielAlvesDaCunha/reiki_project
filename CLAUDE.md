# Conecn't Reiki — CLAUDE.md

Aplicativo Flutter desenvolvido na **Fiocruz** para prática do Yantra (desenho dos símbolos sagrados do Reiki). Ferramenta de apoio às Práticas Integrativas e Complementares em Saúde (PICS) — regulamentadas no SUS pela Portaria GM/MS nº 849/2017.

---

## Stack

- Flutter 3.41.1 / Dart 3.7
- **Arquitetura:** MVVM — BLoC como ViewModel, GetIt como DI
- **Pacotes:** flutter_bloc, get_it, equatable, dio (preparado para API futura)
- **UI:** Material Design 3, tema escuro roxo (`#6A0DAD`) e dourado (`#FFD700`)

---

## Estrutura

```
lib/
├── core/di/            # setupDependencies() — GetIt
├── core/network/       # DioClient
├── core/routes/        # FadeSlideRoute
├── core/theme/         # AppTheme.dark
├── models/             # ReikiSymbol, ReikiLevel
├── repositories/       # SymbolRepository (abstract) + SymbolRepositoryImpl (local)
├── viewmodels/
│   ├── disclaimer/     # DisclaimerViewModel — AcceptDisclaimer → DisclaimerAccepted
│   ├── symbol/         # SymbolViewModel — LoadSymbols, FilterByLevel, SelectSymbol
│   └── drawing/        # DrawingViewModel — traços, cor, espessura, guia (showGuide)
└── views/
    ├── pages/          # DisclaimerPage, HomePage, SymbolDetailPage, DrawingPage
    └── widgets/        # SymbolCard, DrawingCanvas, ChokuReiGuide
```

---

## Navegação

```
DisclaimerPage → HomePage → SymbolDetailPage → DrawingPage
```

- `DisclaimerPage → HomePage`: `pushReplacement` ao aceitar os termos
- `HomePage → SymbolDetailPage`: `FadeSlideRoute`
- `SymbolDetailPage → DrawingPage`: `FadeSlideRoute`
- `DrawingPage`: BlocProvider local (DrawingViewModel não está no GetIt)

---

## Símbolos (8 total)

| id | Nome | Nível |
|---|---|---|
| `choku_rei` | Choku Rei | I |
| `seiheki` | Seiheki | II |
| `honshazeshonen` | Honshazeshonen | II |
| `daikoomyo_usui` | Daikoomyo Usui | III A |
| `daikoomyo_tibetano` | Daikoomyo Tibetano | III B |
| `serpente_fogo` | Serpente de Fogo | III B |
| `raku` | Raku Tibetano | III B |
| `la_hanna_nai` | La Hanna Nai | III B |

---

## DrawingPage — detalhes

- **Phone portrait:** canvas + toolbar inferior (cores, espessura, botão guia)
- **Phone landscape:** canvas cheio + painel lateral animado (hamburguer)
- **Tablet:** canvas + toolbar inferior (sem sidebar — referência removida)
- **Canvas:** coordenadas normalizadas (origem = centro, 1 unidade = min(w,h))
  - 1 dedo → desenha (60fps via ValueNotifier)
  - 2 dedos → zoom/pan (0.3x–8.0x)

### Guia de setas (ChokuReiGuide)
- Só existe para `choku_rei` (único símbolo com guia implementado)
- Camada `IgnorePointer` no fundo do canvas, opacidade 30%, cor dourada
- Toggle via `DrawingGuideToggled` event → `state.showGuide`
- Painter vetorial puro: 3 setas numeradas (sem desenho do símbolo)
  - Seta 1: horizontal (traço do topo)
  - Seta 2: vertical longa (descida)
  - Seta 3: arco curvo na espiral externa (sentido horário)

---

## Convenções

- Responsividade via `MediaQuery.sizeOf()` + `.clamp(min, max)`
- Tablet: `shortestSide >= 600`
- Cores hardcoded (sem usar `Theme` onde precisa de precisão)
- `copyWith()` em todos os states
- Português BR em toda a UI
