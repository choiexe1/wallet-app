import 'package:wallet_app/core/entities/wallet.dart';

abstract interface class WalletGenerator {
  Future<Wallet> generate();
}
