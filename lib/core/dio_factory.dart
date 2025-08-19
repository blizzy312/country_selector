import 'package:dio/dio.dart';

class DioFactory {
  static Dio create() {
    final options = BaseOptions(
      baseUrl: 'https://68a2b00ac5a31eb7bb1d7ad2.mockapi.io/api/v1',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    );
    final dio = Dio(options);
    return dio;
  }
}
