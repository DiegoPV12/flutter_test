import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.errorIconSize,
    this.borderRadius,
  });

  final String url;
  final BoxFit fit;
  final Color? placeholderColor;
  final double? errorIconSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = placeholderColor ?? theme.colorScheme.surfaceContainerHighest;

    final image = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => Container(color: bg),
      errorWidget: (_, _, _) => Container(
        color: bg,
        alignment: Alignment.center,
        child: Icon(Icons.broken_image_outlined, size: errorIconSize),
      ),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
