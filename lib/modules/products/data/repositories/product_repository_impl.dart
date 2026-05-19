import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<List<Product>> searchProducts(String query) =>
      _remote.searchProducts(query);

  @override
  Future<Product> getProductById(int id) => _remote.getProductById(id);

  @override
  Future<List<Product>> getRecommendedProducts({
    int limit = 10,
    int skip = 0,
  }) =>
      _remote.getRecommendedProducts(limit: limit, skip: skip);

  @override
  Future<List<Product>> getRecentProducts() => _local.getRecentProducts();

  @override
  Future<void> saveRecentProduct(Product product) =>
      _local.saveRecentProduct(product);
}
