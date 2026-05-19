import 'dart:math';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetRecommendedProducts {
  GetRecommendedProducts(this._repository, {Random? random})
      : _random = random ?? Random();

  final ProductRepository _repository;
  final Random _random;

  static const int _defaultLimit = 10;
  static const int _catalogSize = 194;

  Future<List<Product>> call({int limit = _defaultLimit}) {
    final maxSkip = (_catalogSize - limit).clamp(0, _catalogSize);
    final skip = maxSkip == 0 ? 0 : _random.nextInt(maxSkip);
    return _repository.getRecommendedProducts(limit: limit, skip: skip);
  }
}
