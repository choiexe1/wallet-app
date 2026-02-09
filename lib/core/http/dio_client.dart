import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioClient with DioMixin implements Dio {
  DioClient({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
    List<Interceptor>? interceptors,
  }) {
    options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );
    httpClientAdapter = IOHttpClientAdapter();
    if (interceptors != null) {
      this.interceptors.addAll(interceptors);
    }
  }
}
