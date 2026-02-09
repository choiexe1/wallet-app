import 'package:wallet_app/core/entities/account.dart';
import 'package:wallet_app/core/entities/wallet.dart';

abstract interface class WalletRepository {
  Future<Wallet> createWallet();
  Future<Wallet> importWallet(String mnemonic);
  Future<Account> addAccount(String walletId);
  Future<Wallet?> loadWallet();
  Future<void> deleteWallet();
}
