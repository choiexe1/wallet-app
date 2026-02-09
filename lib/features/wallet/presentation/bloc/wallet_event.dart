import 'package:equatable/equatable.dart';
import 'package:wallet_app/core/entities/token.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

final class WalletLoaded extends WalletEvent {
  const WalletLoaded();
}

final class WalletDeleted extends WalletEvent {
  const WalletDeleted();
}

final class AccountAdded extends WalletEvent {
  const AccountAdded();
}

final class TokenSelected extends WalletEvent {
  const TokenSelected(this.token);

  final Token token;

  @override
  List<Object?> get props => [token];
}
