import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/controllers/profile_controller.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import 'product_card.dart';

/// [ProductCard] wired to the favourites box — heart state stays live and
/// toggling writes to Hive without needing a bloc refresh.
class FavProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const FavProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final profileFunctions =
        Get.find<ProfileController>().profileFunctions;

    return ListenableBuilder(
      listenable: profileFunctions.favoriteListenable(),
      builder: (context, _) {
        final isFav =
            profileFunctions.isInFavoriteBox(productEntity: product);
        return ProductCard(
          product: product,
          isFavorite: isFav,
          onTap: onTap,
          onFavorite: () async {
            if (isFav) {
              await profileFunctions.removeFavorite(productEntity: product);
            } else {
              await profileFunctions.addToFavorite(productEntity: product);
            }
            onFavorite?.call();
          },
        );
      },
    );
  }
}
