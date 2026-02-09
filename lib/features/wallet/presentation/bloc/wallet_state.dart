import 'package:equatable/equatable.dart';

import 'package:wallet_app/core/entities/wallet.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletLoadSuccess extends WalletState {
  const WalletLoadSuccess(this.wallet);

  final Wallet wallet;

  @override
  List<Object?> get props => [wallet];
}

final class WalletFailure extends WalletState {
  const WalletFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
