import 'package:equatable/equatable.dart';

import '../../models/reiki_symbol.dart';

abstract class SymbolEvent extends Equatable {
  const SymbolEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymbols extends SymbolEvent {
  const LoadSymbols();
}

class FilterByLevel extends SymbolEvent {
  final ReikiLevel? level;
  const FilterByLevel(this.level);

  @override
  List<Object?> get props => [level];
}

class SelectSymbol extends SymbolEvent {
  final String symbolId;
  const SelectSymbol(this.symbolId);

  @override
  List<Object?> get props => [symbolId];
}
