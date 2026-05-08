import 'dart:ui';

import '../viewmodels/drawing/drawing_state.dart';

class SavedDrawing {
  final String id;
  final String symbolId;
  final String symbolName;
  final String name;
  final DateTime savedAt;
  final List<DrawingStroke> strokes;

  const SavedDrawing({
    required this.id,
    required this.symbolId,
    required this.symbolName,
    required this.name,
    required this.savedAt,
    required this.strokes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbolId': symbolId,
        'symbolName': symbolName,
        'name': name,
        'savedAt': savedAt.toIso8601String(),
        'strokes': strokes.map(_strokeToJson).toList(),
      };

  static SavedDrawing fromJson(Map<String, dynamic> json) => SavedDrawing(
        id: json['id'] as String,
        symbolId: json['symbolId'] as String,
        symbolName: json['symbolName'] as String,
        name: json['name'] as String,
        savedAt: DateTime.parse(json['savedAt'] as String),
        strokes: (json['strokes'] as List)
            .map((s) => _strokeFromJson(s as Map<String, dynamic>))
            .toList(),
      );

  static Map<String, dynamic> _strokeToJson(DrawingStroke s) => {
        'pts': s.points.map((p) => [p.dx, p.dy]).toList(),
        'c': s.color.toARGB32(),
        'w': s.strokeWidth,
      };

  static DrawingStroke _strokeFromJson(Map<String, dynamic> m) => DrawingStroke(
        points: (m['pts'] as List)
            .map((p) => Offset(
                  (p[0] as num).toDouble(),
                  (p[1] as num).toDouble(),
                ))
            .toList(),
        color: Color(m['c'] as int),
        strokeWidth: (m['w'] as num).toDouble(),
      );
}
