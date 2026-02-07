import 'dart:typed_data';

import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;

class KeyPair {
  const KeyPair(this.privateKey, this.publicKey);

  final Uint8List privateKey;
  final Uint8List publicKey;
}

abstract interface class HdKeyDerivator {
  Future<KeyPair> generateKey(String mnemonic, {int index = 0});
}

class HdKeyDerivatorImpl implements HdKeyDerivator {
  const HdKeyDerivatorImpl();

  // 강화 파생이 적용된 파생경로
  static const String _ethBasePath = "m/44'/60'/0'/0";

  String _getPath(int index) => "$_ethBasePath/$index";

  @override
  Future<KeyPair> generateKey(String mnemonic, {int index = 0}) async {
    // 니모닉을 PBKDF2로 2048번 해싱
    final seed = bip39.mnemonicToSeed(mnemonic);

    // 해싱 결과로 마스터 키 생성
    // HMAC-SHA512로 해싱해서 앞 256비트는 마스터 개인키로 쓰고, 뒤 256비트는 체인 코드로 씀
    // bip32 패키지 내부에서 hmac-sha512 연산을 해주고 있음..
    final root = BIP32.fromSeed(seed);
    final child = root.derivePath(_getPath(index));

    return KeyPair(child.privateKey!, child.publicKey);
  }
}
