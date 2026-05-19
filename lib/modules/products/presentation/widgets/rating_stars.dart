import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 24,
    this.color = Colors.amber,
  });

  final double rating;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final delta = rating - i;
        final icon = delta >= 0.75
            ? Icons.star_rounded
            : delta >= 0.25
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(icon, size: size, color: color),
        );
      }),
    );
  }
}
