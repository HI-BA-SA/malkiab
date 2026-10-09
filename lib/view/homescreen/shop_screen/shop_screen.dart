import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../widgets/design/design.dart';
import '../homedetails_screen/detail_screen.dart';

/// Pushed “See all” page — full grid of a product selection.
class ShopScreen extends StatelessWidget {
  const ShopScreen({
    super.key,
    required this.title,
    required this.productList,
  });

  final String title;
  final List<ProductEntity> productList;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: productList.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'Nothing here yet',
                message: 'This edit is being restocked.',
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.66,
              ),
              itemCount: productList.length,
              itemBuilder: (context, i) {
                final p = productList[i];
                return FavProductCard(
                  product: p,
                  onTap: () => Get.to(() => DetailScreen(productEntity: p)),
                );
              },
            ),
    );
  }
}
