import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../configs/configs.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import 'price_text.dart';
import 'product_image.dart';
import 'rating_stars.dart';

/// The catalogue card: image, badge, wishlist heart, rating, shades, price.
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.86,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductImage(
                url: product.imageUrl,
                borderRadius: BorderRadius.circular(20),
              ),
              if (product.badge.isNotEmpty)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: scheme.surface.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      product.badge,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
              if (onFavorite != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onFavorite,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: scheme.surface.withOpacity(0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFavorite ? scheme.primary : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (product.brand.isNotEmpty)
          Text(
            product.brand.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.l2?.copyWith(color: scheme.onSurfaceVariant),
          ),
        const SizedBox(height: 3),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppText.b2b?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            RatingStars(rating: product.rating, size: 13),
            const Spacer(),
            if (product.shades.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: product.shades
                    .take(4)
                    .map(
                      (hex) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: _shade(hex),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.outlineVariant,
                            width: 0.8,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        const SizedBox(height: 8),
        PriceText(price: product.price),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: width == null ? card : SizedBox(width: width, child: card),
      ),
    ).animate().fadeIn(duration: 380.ms).slideY(begin: 0.06, curve: Curves.easeOut);
  }

  static Color _shade(String hex) {
    final value = hex.replaceAll('#', '');
    if (value.length != 6) return const Color(0xFFB76E79);
    return Color(int.parse('FF$value', radix: 16));
  }
}
