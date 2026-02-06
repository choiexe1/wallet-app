import 'dart:math';

class EntropyGenerator {
  final Random _random = Random.secure();

  Future<List<int>> generate(int length) async {
    return List.generate(length, (_) => _random.nextInt(256));
  }
}
