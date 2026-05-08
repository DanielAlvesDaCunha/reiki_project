import '../models/saved_drawing.dart';

abstract class DrawingSaveRepository {
  Future<List<SavedDrawing>> loadAll(String symbolId);
  Future<void> save(SavedDrawing drawing);
  Future<void> delete(String id);
}
