import 'dart:typed_data';

class ExtendedKey {
  const ExtendedKey({required this.privateKey, required this.chainCode});

  final Uint8List privateKey;
  final Uint8List chainCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ExtendedKey) return false;
    if (privateKey.length != other.privateKey.length) return false;
    if (chainCode.length != other.chainCode.length) return false;

    for (int i = 0; i < privateKey.length; i++) {
      if (privateKey[i] != other.privateKey[i]) return false;
    }

    for (int i = 0; i < chainCode.length; i++) {
      if (chainCode[i] != other.chainCode[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(privateKey), Object.hashAll(chainCode));

  @override
  String toString() {
    return 'ExtendedKey(privateKey: ${privateKey.join(', ')}, chainCode: ${chainCode.join(', ')})';
  }
}
