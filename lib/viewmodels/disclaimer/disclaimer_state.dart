import 'package:equatable/equatable.dart';

abstract class DisclaimerState extends Equatable {
  const DisclaimerState();

  @override
  List<Object?> get props => [];
}

class DisclaimerPending extends DisclaimerState {
  const DisclaimerPending();
}

class DisclaimerAccepted extends DisclaimerState {
  const DisclaimerAccepted();
}
