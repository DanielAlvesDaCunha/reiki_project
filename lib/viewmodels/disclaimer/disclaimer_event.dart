import 'package:equatable/equatable.dart';

abstract class DisclaimerEvent extends Equatable {
  const DisclaimerEvent();

  @override
  List<Object?> get props => [];
}

class AcceptDisclaimer extends DisclaimerEvent {
  const AcceptDisclaimer();
}
