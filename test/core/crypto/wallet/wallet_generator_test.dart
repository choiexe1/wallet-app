import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator_impl.dart';

class _FixedEntropyGenerator implements EntropyGenerator {
  const _FixedEntropyGenerator(this._entropy);

  final Uint8List _entropy;

  @override
  Future<Uint8List> generate(EntropySize size) async => _entropy;
}

void main() {
  group('WalletGenerator', () {
    test('알려진 니모닉으로 account 0 주소를 파생한다', () async {
      final generator = WalletGeneratorImpl(
        _FixedEntropyGenerator(Uint8List(16)),
      );

      final mnemonic = await generator.generateMnemonic();
      final account = await generator.deriveAccount(mnemonic, 0);

      expect(
        account.address.toLowerCase(),
        '0x9858effd232b4033e47d90003d41ec34ecaeda94',
      );
    });

    test('주소는 0x + 40자 hex 형식이다', () async {
      final generator = WalletGeneratorImpl(
        _FixedEntropyGenerator(Uint8List(16)),
      );

      final mnemonic = await generator.generateMnemonic();
      final account = await generator.deriveAccount(mnemonic, 0);

      expect(account.address, startsWith('0x'));
      expect(account.address.length, 42);
      expect(RegExp(r'^0x[0-9a-f]{40}$').hasMatch(account.address), isTrue);
    });

    test('같은 니모닉에서 다른 account index는 다른 주소를 파생한다', () async {
      final generator = WalletGeneratorImpl(
        _FixedEntropyGenerator(Uint8List(16)),
      );

      final mnemonic = await generator.generateMnemonic();
      final account0 = await generator.deriveAccount(mnemonic, 0);
      final account1 = await generator.deriveAccount(mnemonic, 1);

      expect(account0.address, isNot(equals(account1.address)));
    });
  });
}
