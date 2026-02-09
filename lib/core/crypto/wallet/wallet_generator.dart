import 'package:wallet_app/core/entities/account_credentials.dart';

abstract interface class WalletGenerator {
  Future<String> generateMnemonic();
  Future<AccountCredentials> deriveAccount(String mnemonic, int accountIndex);
}
