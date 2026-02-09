import 'package:flutter/services.dart';

enum EntropySize { bits128, bits256 }

abstract interface class EntropyGenerator {
  Future<Uint8List> generate(EntropySize size);
}
