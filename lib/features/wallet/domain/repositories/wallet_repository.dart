import 'package:wallet_app/core/entities/wallet.dart';

abstract interface class WalletRepository {
  Future<Wallet> createWallet();
  Future<Wallet?> loadWallet();
}
