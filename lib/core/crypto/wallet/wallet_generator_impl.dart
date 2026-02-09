import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/digests/keccak.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:wallet_app/core/crypto/bip39/words.dart';
import 'package:wallet_app/core/crypto/entropy/entropy_generator.dart';
import 'package:wallet_app/core/crypto/wallet/wallet_generator.dart';
import 'package:wallet_app/core/entities/account_credentials.dart';
import 'package:wallet_app/core/entities/extended_key.dart';

class WalletGeneratorImpl implements WalletGenerator {
  const WalletGeneratorImpl(this._entropyGenerator);

  final EntropyGenerator _entropyGenerator;

  static final ECDomainParameters _secp256k1 = ECCurve_secp256k1();
  static final BigInt _n = _secp256k1.n;
  static final KeccakDigest _keccak = KeccakDigest(256);

  @override
  Future<String> generateMnemonic() async {
    final words = await _generateWords();
    return words.join(' ');
  }

  @override
  Future<AccountCredentials> deriveAccount(
    String mnemonic,
    int accountIndex,
  ) async {
    final seed = await _deriveSeed(mnemonic);
    final masterKey = _deriveMasterKey(seed);
    final path = "m/44'/60'/$accountIndex'/0/0";
    final childKey = _derivePath(masterKey, path);
    final address = _deriveAddress(childKey.privateKey);
    final privateKeyHex = childKey.privateKey
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    return AccountCredentials(privateKey: privateKeyHex, address: address);
  }

  Future<List<String>> _generateWords() async {
    final entropy = await _entropyGenerator.generate(EntropySize.bits128);
    final entropyHex = entropy
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();

    final hash = sha256.convert(entropy).toString();
    final entropyWithChecksum = entropyHex + hash[0];

    final bits = entropyWithChecksum
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

  Future<Uint8List> _deriveSeed(String mnemonic, {String? passphrase}) async {
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

  ExtendedKey _deriveMasterKey(Uint8List seed) {
    final result = Hmac(
      sha512,
      utf8.encode("Bitcoin seed"),
    ).convert(seed).bytes;

    return ExtendedKey(
      privateKey: Uint8List.fromList(result.sublist(0, 32)),
      chainCode: Uint8List.fromList(result.sublist(32)),
    );
  }

  ExtendedKey _deriveChildKey(
    ExtendedKey parent,
    int index, {
    required bool hardened,
  }) {
    final data = Uint8List(37);

    if (hardened) {
      data[0] = 0x00;
      data.setRange(1, 33, parent.privateKey);
      index += 0x80000000;
    } else {
      final pubKey = _compressedPublicKey(parent.privateKey);
      data.setRange(0, 33, pubKey);
    }

    data[33] = (index >> 24) & 0xff;
    data[34] = (index >> 16) & 0xff;
    data[35] = (index >> 8) & 0xff;
    data[36] = index & 0xff;

    final hmacResult = Hmac(sha512, parent.chainCode).convert(data).bytes;

    final il = _bytesToBigInt(hmacResult.sublist(0, 32));
    final parentKey = _bytesToBigInt(parent.privateKey);
    final childKey = (il + parentKey) % _n;

    return ExtendedKey(
      privateKey: _bigIntToBytes(childKey, 32),
      chainCode: Uint8List.fromList(hmacResult.sublist(32)),
    );
  }

  ExtendedKey _derivePath(ExtendedKey master, String path) {
    final segments = path.split('/').skip(1);
    var key = master;

    for (final segment in segments) {
      final hardened = segment.endsWith("'");
      final index = int.parse(segment.replaceAll("'", ""));
      key = _deriveChildKey(key, index, hardened: hardened);
    }

    return key;
  }

  Uint8List _compressedPublicKey(Uint8List privateKey) {
    final d = _bytesToBigInt(privateKey);
    final point = _secp256k1.G * d;

    return point!.getEncoded(true);
  }

  String _deriveAddress(Uint8List privateKey) {
    final d = _bytesToBigInt(privateKey);
    final point = _secp256k1.G * d;
    final uncompressed = point!.getEncoded(false);

    _keccak.reset();
    final hash = _keccak.process(uncompressed.sublist(1));

    final addressBytes = hash.sublist(12);
    final addressHex = addressBytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    return '0x$addressHex';
  }

  BigInt _bytesToBigInt(List<int> bytes) {
    BigInt result = BigInt.zero;
    for (final byte in bytes) {
      result = (result << 8) | BigInt.from(byte);
    }
    return result;
  }

  Uint8List _bigIntToBytes(BigInt number, int length) {
    final bytes = Uint8List(length);
    var n = number;
    for (int i = length - 1; i >= 0; i--) {
      bytes[i] = (n & BigInt.from(0xff)).toInt();
      n = n >> 8;
    }
    return bytes;
  }
}
