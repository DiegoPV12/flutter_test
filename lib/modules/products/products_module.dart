import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/dio_client.dart';
import 'data/datasources/product_local_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_recommended_products.dart';
import 'presentation/blocs/detail/detail_bloc.dart';
import 'presentation/blocs/recent/recent_bloc.dart';
import 'presentation/blocs/recommended/recommended_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'presentation/pages/detail_page.dart';
import 'presentation/pages/home_page.dart';

class ProductsModule extends Module {
  ProductsModule(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  void binds(Injector i) {
    // Infrastructure
    i.addSingleton<SharedPreferences>(() => _sharedPreferences);
    i.addLazySingleton<DioClient>(DioClient.new);
    i.addLazySingleton<Dio>(() => i<DioClient>().instance);

    // Data sources
    i.addLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(i()),
    );
    i.addLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(i()),
    );

    // Repository
    i.addLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remote: i(), local: i()),
    );

    // Use cases
    i.addLazySingleton(() => GetRecommendedProducts(i()));

    // BLoCs
    i.addLazySingleton(() => SearchBloc(i()));
    i.addLazySingleton(() => RecentBloc(i()));
    i.addLazySingleton(() => RecommendedBloc(i()));
    i.add(() => DetailBloc(i()));
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
    r.child(
      '/detail/:id',
      child: (_) =>
          DetailPage(productId: int.parse(r.args.params['id'] as String)),
    );
  }
}
