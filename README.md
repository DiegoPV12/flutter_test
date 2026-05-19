# Products Catalog

App de Flutter para explorar productos de [DummyJSON](https://dummyjson.com/docs). Busqueda de productos, detalles, la app recuerda los últimos 5 productos visitados.

## Ejecutar la App

```bash
flutter pub get
flutter run
```

Flutter 3.41 o superior.
API  pública.

## Funcionalidades

- **Home**: bienvenida, search bar, carrusel de "vistos recientemente" y grid de "recomendados para ti".
- **Búsqueda**: con debounce de 350 ms. Los resultados se muestran en un grid masonry de dos columnas.
- **Detalle**: imagen como hero, rating en estrellas, badge de stock, chips de marca/categoría, descripción y un botón "Comprar por $X".
- **Recientes**: persistencia con `shared_preferences`.

## Decisiones técnicas

- **`flutter_modular`** para estructura, navegación y DI.
- **`dio`** como cliente HTTP.
- **`flutter_bloc`** para gestión de estado.
- **`shared_preferences`** para persistencia local. El dataset es chico (5 items en JSON), no hace falta Hive ni SQLite.

- **Clean Architecture ** en 3 capas (domain/data/presentation), pero **sin use cases que solo delegan al repo**. El único que sobrevive es `GetRecommendedProducts`, que tiene lógica real. Los BLoCs llaman al `ProductRepository` directo.
- **Una sola clase `Product`** con `fromJson`/`toJson`. No hice un `ProductModel` apartepara una app con una sola entidad.
- **BLoCs desacoplados**: el `DetailBloc` no conoce al `RecentBloc`. Cuando guarda un producto, un `BlocListener` en la `DetailPage` se encarga de refrescar la lista de recientes.
- **Search**: usa `ValueListenableBuilder` sobre el `TextEditingController` como única fuente de verdad para saber si hay query.
- **Theme**: paleta basada en burdeos `#9E2B25`, armada a mano, Tipografías Sora (títulos) + Plus Jakarta Sans (cuerpos) vía Google Fonts.

## Estructura

```
lib/
├── main.dart, app_module.dart, app_widget.dart
├── core/ (dio_client, failures + messageOf helper, theme)
└── modules/products/
    ├── data/         (remote + local datasources, repository impl)
    ├── domain/       (Product, ProductRepository, GetRecommendedProducts)
    └── presentation/
        ├── blocs/    (search, detail, recent, recommended)
        ├── pages/    (home_page, detail_page)
        └── widgets/  (product_image, inline_error, rating_stars,
                       stock_badge, masonry_product_grid,
                       recent/recommended sections)
```


## Mejoras Futuras

- **Tests unitarios y de widget**. Las capas están listas para testear (los BLoCs reciben `ProductRepository` por constructor, fácil de mockear con `mocktail`), pero no los incluí en esta entrega.
- **Paginación** en la búsqueda con scroll infinito.
- **Caché offline** con `dio_cache_interceptor` o un repo con fallback.
- **Deep links** seguros (validar `productId` con `int.tryParse`).
- **Internacionalización** (es/en) con `flutter_localizations`.

