import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator_impl.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator_impl.dart';

void main() {
  late WalletGenerator generator;

  setUp(() {
    generator = WalletGeneratorImpl(EntropyGeneratorImpl(Random()));
  });

  group('WalletGenerator', () {
    test('지갑 생성', () async {
      final wallet = await generator.generate();

      print(wallet);
    });
  });
}
