class Token {
  const Token({
    required this.symbol,
    required this.name,
    required this.decimals,
    this.contractAddress,
  });

  final String symbol;
  final String name;
  final int decimals;
  final String? contractAddress; // null = native token

  bool get isNative => contractAddress == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Token &&
          symbol == other.symbol &&
          contractAddress == other.contractAddress;

  @override
  int get hashCode => Object.hash(symbol, contractAddress);
}

abstract class SupportedTokens {
  static const pol = Token(symbol: 'POL', name: 'Polygon', decimals: 18);

  static const usdc = Token(
    symbol: 'USDC',
    name: 'USD Coin',
    decimals: 6,
    contractAddress: '0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582',
  );

  static const myto = Token(
    symbol: 'MYTO',
    name: 'Myto',
    decimals: 18,
    contractAddress: '0x7dD7c0c8b792a2b819f85DA3c7d978C7225A3Ebf',
  );

  static const all = [pol, usdc, myto];
}
