import 'package:flutter/material.dart';

/// Compact star rating with optional review count.
class RatingStars extends StatelessWidget {
  final double rating;
  final int count;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.count = 0,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size + 2, color: const Color(0xFFE2B455)),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size - 1,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: size - 2,
              fontWeight: FontWeight.w500,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
