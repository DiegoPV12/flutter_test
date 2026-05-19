import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/product.dart';
import 'product_image.dart';

class MasonryProductGrid extends StatelessWidget {
  const MasonryProductGrid({super.key, required this.products});

  final List<Product> products;

  static const List<double> _heightCycle = [220, 160, 190, 240];

  @override
  Widget build(BuildContext context) {
    final left = <_MasonryItem>[];
    final right = <_MasonryItem>[];
    for (var i = 0; i < products.length; i++) {
      final tile = _MasonryItem(
        product: products[i],
        imageHeight: _heightCycle[i % _heightCycle.length],
      );
      (i.isEven ? left : right).add(tile);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _MasonryColumn(items: left)),
          const SizedBox(width: 12),
          Expanded(child: _MasonryColumn(items: right)),
        ],
      ),
    );
  }
}

class _MasonryColumn extends StatelessWidget {
  const _MasonryColumn({required this.items});
  final List<_MasonryItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 12),
            child: _MasonryCard(item: items[i]),
          ),
      ],
    );
  }
}

class _MasonryItem {
  const _MasonryItem({required this.product, required this.imageHeight});
  final Product product;
  final double imageHeight;
}

class _MasonryCard extends StatelessWidget {
  const _MasonryCard({required this.item});
  final _MasonryItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = item.product;
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Modular.to.pushNamed('/detail/${product.id}'),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: item.imageHeight,
                width: double.infinity,
                child: ProductImage(
                  url: product.thumbnail,
                  placeholderColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
