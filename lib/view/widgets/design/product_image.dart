import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'shimmer_box.dart';

/// Network image with a shimmer placeholder and a blush error fallback.
class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const ProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget image;
    if (url.isEmpty) {
      image = _fallback(scheme);
    } else {
      image = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ShimmerBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          radius: borderRadius?.bottomLeft.x ?? 16,
        ),
        errorWidget: (context, url, error) => _fallback(scheme),
      );
    }
    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: SizedBox(width: width, height: height, child: image),
      ),
    );
  }

  Widget _fallback(ColorScheme scheme) => Container(
        width: width,
        height: height,
        color: scheme.surfaceVariant,
        alignment: Alignment.center,
        child: Icon(Icons.spa_outlined, size: 32, color: scheme.primary),
      );
}
