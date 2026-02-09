import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/core/hd_key_derivator.dart';

void main() {
  late HdKeyDerivator keyDerivator;

  setUp(() {
    keyDerivator = const HdKeyDerivatorImpl();
  });

  group('HdKeyDerivator', () {
    const testMnemonic =
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about';

    test('같은 니모닉이면 같은 개인키 생성', () async {
      final key1 = await keyDerivator.generateKey(testMnemonic);
      final key2 = await keyDerivator.generateKey(testMnemonic);

      expect(
        const ListEquality().equals(key1.privateKey, key2.privateKey),
        isTrue,
      );
    });

    test('개인키는 32바이트', () async {
      final key = await keyDerivator.generateKey(testMnemonic);

      expect(key.privateKey.length, equals(32));
    });

    test('다른 인덱스면 다른 개인키 생성', () async {
      final key0 = await keyDerivator.generateKey(testMnemonic, index: 0);
      final key1 = await keyDerivator.generateKey(testMnemonic, index: 1);

      expect(
        const ListEquality().equals(key0.privateKey, key1.privateKey),
        isFalse,
      );
    });

    test('다른 니모닉이면 다른 개인키 생성', () async {
      const otherMnemonic = 'zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo zoo wrong';

      final key1 = await keyDerivator.generateKey(testMnemonic);
      final key2 = await keyDerivator.generateKey(otherMnemonic);

      expect(
        const ListEquality().equals(key1.privateKey, key2.privateKey),
        isFalse,
      );
    });
  });
}
