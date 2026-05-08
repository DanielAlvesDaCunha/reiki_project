import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawing_event.dart';
import 'drawing_state.dart';

class DrawingViewModel extends Bloc<DrawingEvent, DrawingState> {
  DrawingViewModel({
    DrawingMode mode = DrawingMode.treino,
    bool initialShowGuide = true,
    List<DrawingStroke> initialStrokes = const [],
  }) : super(DrawingState(mode: mode, showGuide: initialShowGuide, strokes: initialStrokes)) {
    on<DrawingStrokeCompleted>(_onStrokeCompleted);
    on<DrawingUndo>(_onUndo);
    on<DrawingClear>(_onClear);
    on<DrawingColorChanged>(_onColorChanged);
    on<DrawingStrokeWidthChanged>(_onStrokeWidthChanged);
    on<DrawingGuideToggled>(_onGuideToggled);
  }

  void _onStrokeCompleted(
      DrawingStrokeCompleted event, Emitter<DrawingState> emit) {
    emit(state.copyWith(strokes: [...state.strokes, event.stroke]));
  }

  void _onUndo(DrawingUndo event, Emitter<DrawingState> emit) {
    if (state.strokes.isEmpty) return;
    final updated = [...state.strokes]..removeLast();
    emit(state.copyWith(strokes: updated));
  }

  void _onClear(DrawingClear event, Emitter<DrawingState> emit) {
    emit(state.copyWith(strokes: []));
  }

  void _onColorChanged(DrawingColorChanged event, Emitter<DrawingState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }

  void _onStrokeWidthChanged(
      DrawingStrokeWidthChanged event, Emitter<DrawingState> emit) {
    emit(state.copyWith(strokeWidth: event.width));
  }

  void _onGuideToggled(
      DrawingGuideToggled event, Emitter<DrawingState> emit) {
    emit(state.copyWith(showGuide: !state.showGuide));
  }
}
