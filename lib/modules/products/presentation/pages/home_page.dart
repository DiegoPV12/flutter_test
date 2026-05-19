import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../blocs/recent/recent_bloc.dart';
import '../blocs/recommended/recommended_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../widgets/inline_error.dart';
import '../widgets/masonry_product_grid.dart';
import '../widgets/recent_products_section.dart';
import '../widgets/recommended_products_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SearchBloc _searchBloc;
  late final RecentBloc _recentBloc;
  late final RecommendedBloc _recommendedBloc;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc = Modular.get<SearchBloc>();
    _recentBloc = Modular.get<RecentBloc>()..add(const RecentRequested());
    _recommendedBloc = Modular.get<RecommendedBloc>()
      ..add(const RecommendedRequested());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _searchBloc),
        BlocProvider.value(value: _recentBloc),
        BlocProvider.value(value: _recommendedBloc),
      ],
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final hasQuery = value.text.trim().isNotEmpty;
              return Column(
                children: [
                  _Header(
                    controller: _controller,
                    hasQuery: hasQuery,
                    onChanged: (v) => _searchBloc.add(SearchQueryChanged(v)),
                    onClear: () {
                      _controller.clear();
                      _searchBloc.add(const SearchCleared());
                    },
                  ),
                  Expanded(
                    child: hasQuery
                        ? BlocBuilder<SearchBloc, SearchState>(
                            builder: (_, searchState) => _SearchResults(
                              state: searchState,
                              onRetry: () => _searchBloc.add(
                                SearchQueryChanged(_controller.text),
                              ),
                            ),
                          )
                        : const _HomeBody(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.hasQuery,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool hasQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Bienvenido a tu tienda\ndigital favorita!',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Descubre productos increíbles',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar productos…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: hasQuery
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClear,
                    )
                  : null,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [_RecentSection(), _RecommendedSection()],
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentBloc, RecentState>(
      builder: (context, state) =>
          RecentProductsSection(products: state.products),
    );
  }
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendedBloc, RecommendedState>(
      builder: (context, state) {
        switch (state.status) {
          case RecommendedStatus.initial:
          case RecommendedStatus.loading:
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            );
          case RecommendedStatus.failure:
            return InlineError(
              message:
                  state.errorMessage ??
                  'No fue posible cargar las recomendaciones.',
              onRetry: () => BlocProvider.of<RecommendedBloc>(
                context,
              ).add(const RecommendedRequested()),
            );
          case RecommendedStatus.success:
            return RecommendedProductsSection(products: state.products);
        }
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.state, required this.onRetry});

  final SearchState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case SearchStatus.initial:
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.failure:
        return InlineError(
          message: state.errorMessage ?? 'Ocurrió un error al buscar.',
          onRetry: onRetry,
        );
      case SearchStatus.success:
        if (state.products.isEmpty) {
          return const _EmptyHint(
            icon: Icons.inbox_outlined,
            text: 'Sin resultados para tu búsqueda.',
          );
        }
        return MasonryProductGrid(products: state.products);
    }
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

