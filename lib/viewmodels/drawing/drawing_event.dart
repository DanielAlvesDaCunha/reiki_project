import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'drawing_state.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object?> get props => [];
}

/// Traço completo — enviado pelo canvas após dedo levantar
class DrawingStrokeCompleted extends DrawingEvent {
  final DrawingStroke stroke;
  const DrawingStrokeCompleted(this.stroke);

  @override
  List<Object?> get props => [stroke];
}

class DrawingUndo extends DrawingEvent {
  const DrawingUndo();
}

class DrawingClear extends DrawingEvent {
  const DrawingClear();
}

class DrawingColorChanged extends DrawingEvent {
  final Color color;
  const DrawingColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

class DrawingStrokeWidthChanged extends DrawingEvent {
  final double width;
  const DrawingStrokeWidthChanged(this.width);

  @override
  List<Object?> get props => [width];
}

class DrawingGuideToggled extends DrawingEvent {
  const DrawingGuideToggled();
}
