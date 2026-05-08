import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/saved_drawing.dart';
import 'drawing_save_repository.dart';

class DrawingSaveRepositoryImpl implements DrawingSaveRepository {
  static const _boxName = 'saved_drawings';

  Future<Box<String>> _openBox() => Hive.openBox<String>(_boxName);

  @override
  Future<List<SavedDrawing>> loadAll(String symbolId) async {
    final box = await _openBox();
    final drawings = box.values
        .map((json) => SavedDrawing.fromJson(
              jsonDecode(json) as Map<String, dynamic>,
            ))
        .where((d) => d.symbolId == symbolId)
        .toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return drawings;
  }

  @override
  Future<void> save(SavedDrawing drawing) async {
    final box = await _openBox();
    await box.put(drawing.id, jsonEncode(drawing.toJson()));
  }

  @override
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
