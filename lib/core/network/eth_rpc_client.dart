import 'package:dio/dio.dart';

class EthRpcClient {
  EthRpcClient(this._dio);

  final Dio _dio;

  int _requestId = 0;

  Future<BigInt> getBalance(String address) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '',
      data: {
        'id': ++_requestId,
        'jsonrpc': '2.0',
        'method': 'eth_getBalance',
        'params': [address, 'latest'],
      },
    );

    final result = response.data?['result'] as String?;
    if (result == null) {
      throw Exception('잔액 조회 실패: ${response.data?['error']}');
    }

    return BigInt.parse(result);
  }

  /// ERC-20 balanceOf(address)
  Future<BigInt> getTokenBalance(String contractAddress, String address) async {
    // balanceOf(address) selector = 0x70a08231
    // address를 32바이트로 패딩
    final paddedAddress = address.replaceFirst('0x', '').padLeft(64, '0');
    final data = '0x70a08231$paddedAddress';

    final response = await _dio.post<Map<String, dynamic>>(
      '',
      data: {
        'id': ++_requestId,
        'jsonrpc': '2.0',
        'method': 'eth_call',
        'params': [
          {'to': contractAddress, 'data': data},
          'latest',
        ],
      },
    );

    final result = response.data?['result'] as String?;
    if (result == null || result == '0x') return BigInt.zero;

    return BigInt.parse(result);
  }

  /// 원시 단위 → 사람이 읽는 단위 (decimals 기반)
  static String formatUnits(BigInt raw, int decimals) {
    final divisor = BigInt.from(10).pow(decimals);
    final whole = raw ~/ divisor;
    final fraction = raw.remainder(divisor);

    final displayDecimals = decimals > 6 ? 6 : decimals;
    final fracStr = fraction.toString().padLeft(decimals, '0');
    final trimmed = fracStr.substring(0, displayDecimals);
    final cleaned = trimmed.replaceAll(RegExp(r'0+$'), '');

    if (cleaned.isEmpty) return '$whole';
    return '$whole.$cleaned';
  }

  /// wei → ETH (소수점 18자리) — 하위호환
  static String weiToEth(BigInt wei) => formatUnits(wei, 18);
}
