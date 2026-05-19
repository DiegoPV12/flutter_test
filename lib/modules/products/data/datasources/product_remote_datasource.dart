import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> searchProducts(String query);
  Future<Product> getProductById(int id);
  Future<List<Product>> getRecommendedProducts({
    required int limit,
    required int skip,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {'q': query, 'limit': 30},
      );
      final data = response.data as Map<String, dynamic>;
      return (data['products'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<List<Product>> getRecommendedProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
          'select': 'id,title,description,price,thumbnail',
        },
      );
      final data = response.data as Map<String, dynamic>;
      return (data['products'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
          'No fue posible conectar con el servidor. Revisa tu conexión.');
    }
    final status = e.response?.statusCode;
    if (status != null) {
      return ServerFailure('Error del servidor ($status).');
    }
    return UnknownFailure(e.message ?? 'Error desconocido');
  }
}
