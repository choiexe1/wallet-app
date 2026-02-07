import 'dart:math';

enum EntropySize { bits128, bits256 }

class EntropyGenerator {
  const EntropyGenerator(this._random);

  final Random _random;

  Future<List<int>> generate(EntropySize size) async {
    int length = size == EntropySize.bits128 ? 16 : 32;
    return List.generate(length, (_) => _random.nextInt(256));
  }
}
