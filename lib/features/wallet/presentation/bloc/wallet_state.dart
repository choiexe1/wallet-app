import 'package:equatable/equatable.dart';

import 'package:wallet_app/core/entities/token.dart';
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
  const WalletLoadSuccess(
    this.wallet, {
    this.balances = const {},
    this.selectedToken = SupportedTokens.pol,
  });

  final Wallet wallet;
  // address → { tokenSymbol → formatted balance }
  final Map<String, Map<String, String>> balances;
  final Token selectedToken;

  WalletLoadSuccess copyWith({
    Wallet? wallet,
    Map<String, Map<String, String>>? balances,
    Token? selectedToken,
  }) {
    return WalletLoadSuccess(
      wallet ?? this.wallet,
      balances: balances ?? this.balances,
      selectedToken: selectedToken ?? this.selectedToken,
    );
  }

  @override
  List<Object?> get props => [wallet, balances, selectedToken];
}

final class WalletFailure extends WalletState {
  const WalletFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
