import 'package:flutter_bloc/flutter_bloc.dart';

import 'disclaimer_event.dart';
import 'disclaimer_state.dart';

class DisclaimerViewModel extends Bloc<DisclaimerEvent, DisclaimerState> {
  DisclaimerViewModel() : super(const DisclaimerPending()) {
    on<AcceptDisclaimer>(_onAccept);
  }

  void _onAccept(AcceptDisclaimer event, Emitter<DisclaimerState> emit) {
    emit(const DisclaimerAccepted());
  }
}
