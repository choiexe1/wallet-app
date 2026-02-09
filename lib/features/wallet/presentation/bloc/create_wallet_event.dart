import 'package:equatable/equatable.dart';

sealed class CreateWalletEvent extends Equatable {
  const CreateWalletEvent();

  @override
  List<Object?> get props => [];
}

final class CreateWalletSubmitted extends CreateWalletEvent {
  const CreateWalletSubmitted();
}

final class ImportWalletSubmitted extends CreateWalletEvent {
  const ImportWalletSubmitted(this.mnemonic);

  final String mnemonic;

  @override
  List<Object?> get props => [mnemonic];
}
