import 'package:equatable/equatable.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

final class WalletLoaded extends WalletEvent {
  const WalletLoaded();
}
