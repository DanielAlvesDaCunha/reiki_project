import '../models/reiki_symbol.dart';

abstract class SymbolRepository {
  List<ReikiSymbol> getAll();
  ReikiSymbol? getById(String id);
  List<ReikiSymbol> getByLevel(ReikiLevel level);
}
