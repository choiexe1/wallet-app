import 'package:crypto/crypto.dart';

abstract interface class Hasher {
  Digest hash(List<int> input);
}

class SHA256Hasher implements Hasher {
  @override
  Digest hash(List<int> input) {
    return sha256.convert(input);
  }
}
