import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/entropy_generator.dart';

void main() {
  late EntropyGenerator generator;

  setUp(() {
    generator = EntropyGenerator(Random.secure());
  });

  group('EntropyGenerator', () {
    test('generates 128-bit 엔트로피', () async {
      final entropy = await generator.generate(EntropySize.bits128);
      expect(entropy.length, 16);
    });

    test('generates 256-bit 엔트로피', () async {
      final entropy = await generator.generate(EntropySize.bits256);
      expect(entropy.length, 32);
    });

    test('생성마다 무작위 엔트로피가 생성되어야 함', () async {
      final entropy1 = await generator.generate(EntropySize.bits256);
      final entropy2 = await generator.generate(EntropySize.bits256);
      expect(entropy1, isNot(entropy2));
    });
  });
}
