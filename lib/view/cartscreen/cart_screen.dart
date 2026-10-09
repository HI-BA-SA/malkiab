import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../configs/app.dart';
import '../../../configs/configs.dart';
import '../../../model/controllers/duplicate_controller.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../rootscreen/root.dart';
import '../widgets/design/design.dart';
import 'bloc/cart_bloc.dart';
import 'checout_screen/check_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? _bloc;

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CartBloc();
        bloc.add(CartStart());
        _bloc = bloc;
        return bloc;
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartSuccess) {
            return _CartContent(
              state: state,
              onChanged: () => _bloc?.add(CartStart()),
            );
          }
          if (state is CartEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Your bag'),
                automaticallyImplyLeading: false,
              ),
              body: Center(
                child: EmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Your bag is empty',
                  message: 'Fill it with something you’ll love.',
                  actionLabel: 'Start shopping',
                  onAction: () => rootTab.value = 1,
                ),
              ),
            );
          }
          if (state is CartError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Your bag'),
                automaticallyImplyLeading: false,
              ),
              body: Center(
                child: GlowButton(
                  label: 'Try again',
                  onPressed: () => _bloc?.add(CartStart()),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartSuccess state;
  final VoidCallback onChanged;

  const _CartContent({required this.state, required this.onChanged});

  List<_Line> get _lines {
    final seen = <int, _Line>{};
    for (final p in state.productList) {
      final line = seen[p.id];
      if (line == null) {
        seen[p.id] = _Line(product: p, qty: 1);
      } else {
        seen[p.id] = _Line(product: p, qty: line.qty + 1);
      }
    }
    return seen.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final cartFunctions = Get.find<DuplicateController>().cartFunctions;
    final lines = _lines;
    final units = state.productList.length;
    final subtotal = double.tryParse(state.totalPrice) ?? 0;
    final delivery = subtotal >= 50 || subtotal == 0 ? 0.0 : 4.9;
    final total = subtotal + delivery;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your bag'),
            Text(
              '$units ${units == 1 ? 'item' : 'items'}',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 260),
            physics: const BouncingScrollPhysics(),
            itemCount: lines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _CartLineCard(
              line: lines[index],
              onQty: (next) async {
                if (next > lines[index].qty) {
                  await cartFunctions
                      .incrementQuantity(product: lines[index].product);
                } else if (next < lines[index].qty) {
                  await cartFunctions
                      .decrementQuantity(productId: lines[index].product.id);
                }
                onChanged();
              },
              onRemove: () async {
                await cartFunctions
                    .removeProduct(productId: lines[index].product.id);
                Get.snackbar(
                  'Removed',
                  '${lines[index].product.name} left your bag',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12),
                  backgroundColor: scheme.primary,
                  colorText: Colors.white,
                );
                onChanged();
              },
            ),
          ),

          // Summary card floats above the frosted tab bar.
          Positioned(
            left: 16,
            right: 16,
            bottom: 88,
            child: SoftCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('Subtotal', style: GoogleFonts.manrope(fontSize: 14)),
                      const Spacer(),
                      PriceText(price: '$subtotal'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Delivery', style: GoogleFonts.manrope(fontSize: 14)),
                      const Spacer(),
                      if (delivery == 0)
                        Text(
                          'Complimentary',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        )
                      else
                        PriceText(
                          price: '$delivery',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 22),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      PriceText(
                        price: '$total',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GlowButton(
                    label: 'Checkout',
                    gradient: true,
                    expanded: true,
                    onPressed: () {
                      Get.to(
                        () => CheckoutScreen(
                          productList: state.productList,
                          totalPrice: total.toStringAsFixed(2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Line {
  final ProductEntity product;
  final int qty;
  const _Line({required this.product, required this.qty});
}

class _CartLineCard extends StatelessWidget {
  final _Line line;
  final ValueChanged<int> onQty;
  final VoidCallback onRemove;

  const _CartLineCard({
    required this.line,
    required this.onQty,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = line.product;
    final unit = double.tryParse(p.price) ?? 0;

    return SoftCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ProductImage(
              url: p.imageUrl,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.brand.isEmpty ? AppStrings.brandName : p.brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    PriceText(
                      price: '${unit * line.qty}',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    QtyStepper(
                      value: line.qty,
                      onChanged: line.qty == 1
                          ? (_) => onRemove()
                          : onQty,
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: onRemove,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: scheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
