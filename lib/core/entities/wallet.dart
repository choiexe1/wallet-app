import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  const Wallet({required this.address, required this.mnemonic});

  final String address;
  final String mnemonic;

  @override
  List<Object?> get props => [address, mnemonic];
}
