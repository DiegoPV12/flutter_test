import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/products/products_module.dart';

class AppModule extends Module {
  AppModule(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.module('/', module: ProductsModule(_sharedPreferences));
  }
}
