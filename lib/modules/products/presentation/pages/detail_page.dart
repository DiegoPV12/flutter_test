import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/product.dart';
import '../blocs/detail/detail_bloc.dart';
import '../blocs/recent/recent_bloc.dart';
import '../widgets/inline_error.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_stars.dart';
import '../widgets/recent_products_section.dart';
import '../widgets/stock_badge.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.productId});

  final int productId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailBloc _detailBloc;
  late final RecentBloc _recentBloc;

  @override
  void initState() {
    super.initState();
    _detailBloc = Modular.get<DetailBloc>()
      ..add(DetailRequested(widget.productId));
    _recentBloc = Modular.get<RecentBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _detailBloc),
        BlocProvider.value(value: _recentBloc),
      ],
      child: BlocListener<DetailBloc, DetailState>(
        listenWhen: (prev, curr) =>
            prev.status != DetailStatus.success &&
            curr.status == DetailStatus.success,
        listener: (_, _) => _recentBloc.add(const RecentRequested()),
        child: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            final product = state.product;
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  _ImageAppBar(imageUrl: product?.thumbnail),
                  ..._contentSlivers(context, state, product),
                ],
              ),
              bottomNavigationBar: product != null
                  ? _BuyButton(product: product)
                  : null,
            );
          },
        ),
      ),
    );
  }

  List<Widget> _contentSlivers(
    BuildContext context,
    DetailState state,
    Product? product,
  ) {
    if (state.status == DetailStatus.success && product != null) {
      return _successSlivers(context, product);
    }
    if (state.status == DetailStatus.failure) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: InlineError(
            message: state.errorMessage ?? 'Ocurrió un error.',
            onRetry: () => _detailBloc.add(DetailRequested(widget.productId)),
          ),
        ),
      ];
    }
    return const [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    ];
  }

  List<Widget> _successSlivers(BuildContext context, Product product) {
    final theme = Theme.of(context);
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Text(product.title, style: theme.textTheme.headlineSmall),
            if (product.rating != null) ...[
              const SizedBox(height: 10),
              RatingStars(rating: product.rating!),
            ],
            if (product.stock != null) ...[
              const SizedBox(height: 18),
              StockBadge(stock: product.stock!),
            ],
            if (product.brand != null || product.category != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (product.brand != null) Chip(label: Text(product.brand!)),
                  if (product.category != null)
                    Chip(label: Text(product.category!)),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Text('Descripción', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(product.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
          ]),
        ),
      ),
      SliverToBoxAdapter(
        child: BlocBuilder<RecentBloc, RecentState>(
          builder: (context, state) {
            final others = state.products
                .where((p) => p.id != product.id)
                .toList(growable: false);
            return RecentProductsSection(products: others);
          },
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];
  }
}

class _ImageAppBar extends StatelessWidget {
  const _ImageAppBar({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 380,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: const Padding(
        padding: EdgeInsets.only(left: 12, top: 8, bottom: 4),
        child: _RoundBackButton(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
          child: (imageUrl == null || imageUrl!.isEmpty)
              ? Container(color: theme.colorScheme.surfaceContainerHighest)
              : ProductImage(url: imageUrl!, errorIconSize: 56),
        ),
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primaryContainer,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Modular.to.pop(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.arrow_back,
            size: 24,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          child: Text(
            'Comprar por \$${product.price.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

