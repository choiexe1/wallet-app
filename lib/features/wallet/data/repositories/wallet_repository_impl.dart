import 'package:wallet_app/core/entities/wallet.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl();

  @override
  Future<Wallet> createWallet() {
    // TODO: implement createWallet
    throw UnimplementedError();
  }

  @override
  Future<Wallet?> loadWallet() {
    // TODO: implement loadWallet
    throw UnimplementedError();
  }
}
