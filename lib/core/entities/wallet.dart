import 'package:wallet_app/core/entities/account.dart';

class Wallet {
  const Wallet({
    required this.id,
    required this.accounts,
    required this.createdAt,
  });

  final String id;
  final List<Account> accounts;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wallet &&
          id == other.id &&
          createdAt == other.createdAt &&
          _listEquals(accounts, other.accounts);

  @override
  int get hashCode => Object.hash(id, createdAt, Object.hashAll(accounts));

  @override
  String toString() =>
      'Wallet(id: $id, accounts: ${accounts.length}, createdAt: $createdAt)';

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
