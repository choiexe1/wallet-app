import 'dart:math';

import 'package:wallet_app/core/crypto/wallet/wallet_generator.dart';
import 'package:wallet_app/core/entities/account.dart';
import 'package:wallet_app/core/entities/wallet.dart';
import 'package:wallet_app/core/storage/storage.dart';
import 'package:wallet_app/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._generator, this._storage);

  final WalletGenerator _generator;
  final Storage _storage;

  static const _walletIdKey = 'wallet_id';

  @override
  Future<Wallet> createWallet() async {
    final mnemonic = await _generator.generateMnemonic();
    final credentials = await _generator.deriveAccount(mnemonic, 0);
    final id = _generateUuid();
    final createdAt = DateTime.now();

    await Future.wait([
      _storage.write(_walletIdKey, id),
      _storage.write('${id}_mnemonic', mnemonic),
      _storage.write('${id}_createdAt', createdAt.toIso8601String()),
      _storage.write('${id}_account_count', '1'),
      _storage.write('${id}_account_0_privateKey', credentials.privateKey),
      _storage.write('${id}_account_0_address', credentials.address),
      _storage.write('${id}_account_0_createdAt', createdAt.toIso8601String()),
    ]);

    return Wallet(
      id: id,
      accounts: [
        Account(index: 0, address: credentials.address, createdAt: createdAt),
      ],
      createdAt: createdAt,
    );
  }

  @override
  Future<Wallet> importWallet(String mnemonic) async {
    final words = mnemonic.trim().split(RegExp(r'\s+'));
    if (words.length != 12) {
      throw ArgumentError('니모닉은 12단어여야 합니다');
    }

    final credentials = await _generator.deriveAccount(mnemonic.trim(), 0);
    final id = _generateUuid();
    final createdAt = DateTime.now();

    await Future.wait([
      _storage.write(_walletIdKey, id),
      _storage.write('${id}_mnemonic', mnemonic.trim()),
      _storage.write('${id}_createdAt', createdAt.toIso8601String()),
      _storage.write('${id}_account_count', '1'),
      _storage.write('${id}_account_0_privateKey', credentials.privateKey),
      _storage.write('${id}_account_0_address', credentials.address),
      _storage.write('${id}_account_0_createdAt', createdAt.toIso8601String()),
    ]);

    return Wallet(
      id: id,
      accounts: [
        Account(index: 0, address: credentials.address, createdAt: createdAt),
      ],
      createdAt: createdAt,
    );
  }

  @override
  Future<Account> addAccount(String walletId) async {
    final mnemonic = await _storage.read('${walletId}_mnemonic');
    final countRaw = await _storage.read('${walletId}_account_count');
    if (mnemonic == null || countRaw == null) {
      throw StateError('Wallet not found: $walletId');
    }

    final nextIndex = int.parse(countRaw);
    final credentials = await _generator.deriveAccount(mnemonic, nextIndex);
    final createdAt = DateTime.now();

    await Future.wait([
      _storage.write('${walletId}_account_count', '${nextIndex + 1}'),
      _storage.write(
        '${walletId}_account_${nextIndex}_privateKey',
        credentials.privateKey,
      ),
      _storage.write(
        '${walletId}_account_${nextIndex}_address',
        credentials.address,
      ),
      _storage.write(
        '${walletId}_account_${nextIndex}_createdAt',
        createdAt.toIso8601String(),
      ),
    ]);

    return Account(
      index: nextIndex,
      address: credentials.address,
      createdAt: createdAt,
    );
  }

  @override
  Future<Wallet?> loadWallet() async {
    final id = await _storage.read(_walletIdKey);
    if (id == null) return null;

    final createdAtRaw = await _storage.read('${id}_createdAt');
    final countRaw = await _storage.read('${id}_account_count');
    if (createdAtRaw == null || countRaw == null) return null;

    final count = int.parse(countRaw);
    final accounts = <Account>[];

    for (int i = 0; i < count; i++) {
      final address = await _storage.read('${id}_account_${i}_address');
      final accountCreatedAtRaw = await _storage.read(
        '${id}_account_${i}_createdAt',
      );
      if (address == null || accountCreatedAtRaw == null) continue;

      accounts.add(
        Account(
          index: i,
          address: address,
          createdAt: DateTime.parse(accountCreatedAtRaw),
        ),
      );
    }

    return Wallet(
      id: id,
      accounts: accounts,
      createdAt: DateTime.parse(createdAtRaw),
    );
  }

  @override
  Future<void> deleteWallet() async {
    final id = await _storage.read(_walletIdKey);
    if (id == null) return;

    final countRaw = await _storage.read('${id}_account_count');
    final count = countRaw != null ? int.parse(countRaw) : 0;

    final deletes = <Future<void>>[
      _storage.delete(_walletIdKey),
      _storage.delete('${id}_mnemonic'),
      _storage.delete('${id}_createdAt'),
      _storage.delete('${id}_account_count'),
    ];

    for (int i = 0; i < count; i++) {
      deletes.add(_storage.delete('${id}_account_${i}_privateKey'));
      deletes.add(_storage.delete('${id}_account_${i}_address'));
      deletes.add(_storage.delete('${id}_account_${i}_createdAt'));
    }

    await Future.wait(deletes);
  }

  String _generateUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20, 32)}';
  }
}
