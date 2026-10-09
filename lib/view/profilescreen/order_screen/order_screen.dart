import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../model/tools/entities/OrderEntity/order_entity.dart';
import '../../widgets/design/design.dart';
import 'bloc/order_bloc.dart';
import 'order_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderBloc? _bloc;

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Order history')),
      body: BlocProvider(
        create: (context) {
          final bloc = OrderBloc();
          _bloc = bloc;
          bloc.add(OrderInitialEvent());
          return bloc;
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderInitialScreen) {
              final orders = state.orderHistoryList;
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orders[orders.length - 1 - index];
                  return _OrderCard(
                    order: order,
                    index: orders.length - index,
                  );
                },
              );
            }
            if (state is OrderEmpty) {
              return Center(
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No orders yet',
                  message: 'When you place an order, it will live here.',
                  actionLabel: 'Start shopping',
                  onAction: () {
                    Get.back();
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final int index;

  const _OrderCard({required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = order.productList.length;
    final date = order.time;

    return SoftCard(
      onTap: () => Get.to(() => OrderDetailScreen(order: order)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'ORDER #100$index',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: scheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: scheme.outline),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < count.clamp(0, 4); i++) ...[
                if (i > 0) const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ProductImage(
                    url: order.productList[i].imageUrl,
                    width: 44,
                    height: 44,
                  ),
                ),
              ],
              if (count > 4)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 11),
                  decoration: BoxDecoration(
                    color: scheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${count - 4}',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              const Spacer(),
              PriceText(
                price: order.totalPrice,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                '${date.day.toString().padLeft(2, '0')}.'
                '${date.month.toString().padLeft(2, '0')}.'
                '${date.year} · $count ${count == 1 ? 'item' : 'items'}',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                'View details',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
