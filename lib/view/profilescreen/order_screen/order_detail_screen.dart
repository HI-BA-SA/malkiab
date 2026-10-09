import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../model/controllers/duplicate_controller.dart';
import '../../../model/tools/entities/OrderEntity/order_entity.dart';
import '../../rootscreen/root.dart';
import '../../widgets/design/design.dart';
import '../../homescreen/homedetails_screen/detail_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});
  final OrderEntity order;

  static const _steps = [
    'Order placed',
    'Packed with care',
    'On the way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final products = order.productList;

    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
        children: [
          // -------------------------------------------------- status
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'DELIVERED',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PriceText(
                      price: order.totalPrice,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                for (var i = 0; i < _steps.length; i++) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                size: 15, color: Colors.white),
                          ),
                          if (i != _steps.length - 1)
                            Container(
                              width: 2,
                              height: 26,
                              color: scheme.primary,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          _steps[i],
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${order.time.day.toString().padLeft(2, '0')}.'
                    '${order.time.month.toString().padLeft(2, '0')}.'
                    '${order.time.year} · '
                    '${order.time.hour.toString().padLeft(2, '0')}:'
                    '${order.time.minute.toString().padLeft(2, '0')}',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Items (${products.length})',
            style: GoogleFonts.playfairDisplay(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (final p in products)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SoftCard(
                onTap: () => Get.to(() => DetailScreen(productEntity: p)),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ProductImage(
                        url: p.imageUrl,
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.brand.isEmpty ? 'malkiab' : p.brand,
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PriceText(price: p.price),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 10),
          SoftCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Items', style: GoogleFonts.manrope(fontSize: 14)),
                    const Spacer(),
                    PriceText(price: order.totalPrice),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Delivery', style: GoogleFonts.manrope(fontSize: 14)),
                    const Spacer(),
                    Text(
                      'Complimentary',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 22),
                Row(
                  children: [
                    Text('Paid',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    PriceText(
                      price: order.totalPrice,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: GlowButton(
          label: 'Buy these again',
          gradient: true,
          onPressed: () async {
            final scheme = Theme.of(context).colorScheme;
            final cart = Get.find<DuplicateController>().cartFunctions;
            for (final p in products) {
              await cart.addToCart(productEntity: p);
            }
            Get.snackbar(
              'Added to bag',
              '${products.length} items are waiting in your bag.',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: scheme.primary,
              colorText: Colors.white,
              mainButton: TextButton(
                onPressed: () {
                  Get.closeAllSnackbars();
                  Get.back();
                  rootTab.value = 2;
                },
                child: Text(
                  'View bag',
                  style: GoogleFonts.manrope(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
