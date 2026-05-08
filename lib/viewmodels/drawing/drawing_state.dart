import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'drawing_event.dart';

class DrawingStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  const DrawingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

class DrawingState extends Equatable {
  final List<DrawingStroke> strokes;
  final Color selectedColor;
  final double strokeWidth;
  final bool showGuide;
  final DrawingMode mode;

  const DrawingState({
    this.strokes = const [],
    this.selectedColor = const Color(0xFFB388FF),
    this.strokeWidth = 4.0,
    this.showGuide = true,
    this.mode = DrawingMode.treino,
  });

  DrawingState copyWith({
    List<DrawingStroke>? strokes,
    Color? selectedColor,
    double? strokeWidth,
    bool? showGuide,
    DrawingMode? mode,
  }) {
    return DrawingState(
      strokes: strokes ?? this.strokes,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      showGuide: showGuide ?? this.showGuide,
      mode: mode ?? this.mode,
    );
  }

  bool get isEmpty => strokes.isEmpty;
  bool get isTreino => mode == DrawingMode.treino;
  bool get isVerificar => mode == DrawingMode.verificar;

  @override
  List<Object?> get props => [strokes, selectedColor, strokeWidth, showGuide, mode];
}
