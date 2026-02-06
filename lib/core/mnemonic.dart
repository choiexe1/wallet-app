class Mnemonic {
  const Mnemonic({required this.mnemonic, required this.seed});

  final String mnemonic;
  final String seed;
}

abstract interface class MnemonicGenerator {
  Future<Mnemonic> generateMnemonic();
}
