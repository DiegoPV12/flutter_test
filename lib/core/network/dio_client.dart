import 'package:dio/dio.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://dummyjson.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            responseType: ResponseType.json,
            headers: {'Accept': 'application/json'},
          ),
        );

  final Dio _dio;

  Dio get instance => _dio;
}
