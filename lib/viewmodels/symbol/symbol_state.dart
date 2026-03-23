import 'package:equatable/equatable.dart';

import '../../models/reiki_symbol.dart';

abstract class SymbolState extends Equatable {
  const SymbolState();

  @override
  List<Object?> get props => [];
}

class SymbolInitial extends SymbolState {
  const SymbolInitial();
}

class SymbolLoaded extends SymbolState {
  final List<ReikiSymbol> symbols;
  final List<ReikiSymbol> filtered;
  final ReikiLevel? activeFilter;

  const SymbolLoaded({
    required this.symbols,
    required this.filtered,
    this.activeFilter,
  });

  SymbolLoaded copyWith({
    List<ReikiSymbol>? symbols,
    List<ReikiSymbol>? filtered,
    ReikiLevel? activeFilter,
    bool clearFilter = false,
  }) {
    return SymbolLoaded(
      symbols: symbols ?? this.symbols,
      filtered: filtered ?? this.filtered,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
    );
  }

  @override
  List<Object?> get props => [symbols, filtered, activeFilter];
}
