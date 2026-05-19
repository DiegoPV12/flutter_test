import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getRecentProducts();
  Future<void> saveRecentProduct(Product product);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _recentKey = 'recent_products';
  static const _maxRecent = 5;

  @override
  Future<List<Product>> getRecentProducts() async {
    try {
      final raw = _prefs.getStringList(_recentKey) ?? const [];
      return raw
          .map((s) =>
              Product.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheFailure('No se pudieron leer los recientes: $e');
    }
  }

  @override
  Future<void> saveRecentProduct(Product product) async {
    try {
      final current = _prefs.getStringList(_recentKey) ?? const [];
      final decoded = current
          .map((s) =>
              Product.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList()
        ..removeWhere((p) => p.id == product.id);

      decoded.insert(0, product);

      final trimmed = decoded.take(_maxRecent).toList();
      final encoded = trimmed.map((p) => jsonEncode(p.toJson())).toList();

      await _prefs.setStringList(_recentKey, encoded);
    } catch (e) {
      throw CacheFailure('No se pudo guardar el producto reciente: $e');
    }
  }
}
