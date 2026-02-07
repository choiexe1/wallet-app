import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

abstract interface class AddressGenerator {
  String generateAddress(Uint8List privateKey);
}

class EVMAddressGenerator implements AddressGenerator {
  @override
  String generateAddress(Uint8List privateKey) {
    final hex = privateKey
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    final credentials = EthPrivateKey.fromHex(hex);
    return credentials.address.hex;
  }
}
