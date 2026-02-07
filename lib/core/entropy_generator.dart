import 'dart:math';

enum EntropySize { bits128, bits256 }

class EntropyGenerator {
  final Random _random = Random.secure();

  Future<List<int>> generate(EntropySize size) async {
    int length = size == EntropySize.bits128 ? 16 : 32;
    return List.generate(length, (_) => _random.nextInt(256));
  }
}
