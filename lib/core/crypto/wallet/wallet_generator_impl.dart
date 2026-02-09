import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/core/crypto/bip39/words.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator.dart';
import 'package:wallet_app/core/entities/wallet.dart';

class WalletGeneratorImpl implements WalletGenerator {
  const WalletGeneratorImpl(this._entropyGenerator);

  final EntropyGenerator _entropyGenerator;

  @override
  Future<Wallet> generate() async {
    final mnemonic = await _bip39();
    final pbkdf2 = await _pbkdf2(mnemonic.join(' '));

    return Wallet(mnemonic: mnemonic.join(' '), address: 'asdf');
  }

  Future<List<String>> _bip39() async {
    final entropy = await _entropyGenerator.generate(EntropySize.bits128);
    final entropyHex = entropy
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();

    final hash = sha256.convert(entropy).toString();
    final entropyChecksum = entropyHex + hash[0];

    final bits = entropyChecksum
        .split('')
        .map(
          (string) =>
              int.parse(string, radix: 16).toRadixString(2).padLeft(4, '0'),
        )
        .join();

    final mnemonic = List.generate(
      12,
      (i) => bip39En[int.parse(bits.substring(i * 11, i * 11 + 11), radix: 2)],
    );

    return mnemonic;
  }

  Future<Uint8List> _pbkdf2(String mnemonic, {String? passphrase}) async {
    final password = utf8.encode(mnemonic);
    final salt = utf8.encode('mnemonic${passphrase ?? ''}');

    final hmac = Hmac(sha512, password);

    List<int> prev = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
    List<int> result = List<int>.from(prev);

    for (int i = 1; i < 2048; i++) {
      prev = hmac.convert(prev).bytes;
      for (int j = 0; j < result.length; j++) {
        result[j] = result[j] ^ prev[j];
      }
    }

    return Uint8List.fromList(result);
  }
}
