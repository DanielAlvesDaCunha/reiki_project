import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/reiki_symbol.dart';
import '../../repositories/symbol_repository.dart';
import 'symbol_event.dart';
import 'symbol_state.dart';

class SymbolViewModel extends Bloc<SymbolEvent, SymbolState> {
  final SymbolRepository _repository;

  SymbolViewModel(this._repository) : super(const SymbolInitial()) {
    on<LoadSymbols>(_onLoad);
    on<FilterByLevel>(_onFilter);
  }

  void _onLoad(LoadSymbols event, Emitter<SymbolState> emit) {
    final all = _repository.getAll();
    emit(SymbolLoaded(symbols: all, filtered: all));
  }

  void _onFilter(FilterByLevel event, Emitter<SymbolState> emit) {
    if (state is! SymbolLoaded) return;
    final current = state as SymbolLoaded;
    if (event.level == null) {
      emit(current.copyWith(filtered: current.symbols, clearFilter: true));
    } else {
      final filtered = current.symbols
          .where((s) => s.minLevel == event.level)
          .toList();
      emit(current.copyWith(filtered: filtered, activeFilter: event.level));
    }
  }

  ReikiSymbol? getById(String id) => _repository.getById(id);
}
