import 'dart:math';
import 'dart:typed_data';

import 'entropy_generator.dart';

class EntropyGeneratorImpl implements EntropyGenerator {
  const EntropyGeneratorImpl(this._random);

  final Random _random;

  @override
  Future<Uint8List> generate(EntropySize size) async {
    final length = size == EntropySize.bits128 ? 16 : 32;
    final bytes = List<int>.generate(length, (_) => _random.nextInt(256));
    return Uint8List.fromList(bytes);
  }
}
