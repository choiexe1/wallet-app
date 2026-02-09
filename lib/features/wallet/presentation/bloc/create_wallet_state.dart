import 'package:equatable/equatable.dart';
import 'package:wallet_app/core/entities/wallet.dart';

sealed class CreateWalletState extends Equatable {
  const CreateWalletState();

  @override
  List<Object?> get props => [];
}

final class CreateWalletInitial extends CreateWalletState {
  const CreateWalletInitial();
}

final class CreateWalletLoading extends CreateWalletState {
  const CreateWalletLoading();
}

final class CreateWalletSuccess extends CreateWalletState {
  const CreateWalletSuccess(this.wallet);

  final Wallet wallet;

  @override
  List<Object?> get props => [wallet];
}

final class CreateWalletFailure extends CreateWalletState {
  const CreateWalletFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
