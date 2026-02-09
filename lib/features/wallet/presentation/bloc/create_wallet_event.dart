import 'package:equatable/equatable.dart';

sealed class CreateWalletEvent extends Equatable {
  const CreateWalletEvent();

  @override
  List<Object?> get props => [];
}

final class CreateWalletSubmitted extends CreateWalletEvent {
  const CreateWalletSubmitted();
}
