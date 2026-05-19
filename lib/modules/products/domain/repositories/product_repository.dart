import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> searchProducts(String query);
  Future<Product> getProductById(int id);
  Future<List<Product>> getRecommendedProducts({int limit, int skip});

  Future<List<Product>> getRecentProducts();
  Future<void> saveRecentProduct(Product product);
}
