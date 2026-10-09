import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../model/controllers/duplicate_controller.dart';
import '../../../model/controllers/profile_controller.dart';
import '../../../model/tools/entities/OrderEntity/order_entity.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../rootscreen/root.dart';
import '../../widgets/design/design.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.totalPrice,
    required this.productList,
    required this.addressDetail,
  });

  final String totalPrice;
  final List<ProductEntity> productList;
  final String addressDetail;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _methodIndex = 0;
  bool _paying = false;

  static const _methods = [
    (icon: Icons.credit_card_rounded, label: 'Card', hint: 'Visa •••• 4242'),
    (icon: Icons.account_balance_wallet_rounded,
        label: 'Wallet',
        hint: 'malkiab balance'),
    (icon: Icons.payments_outlined,
        label: 'Cash on delivery',
        hint: 'Pay when it arrives'),
  ];

  Future<void> _pay() async {
    if (_paying) return;
    final confirmed = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm payment',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Pay \$${widget.totalPrice} with ${_methods[_methodIndex].label}?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              GlowButton(
                label: 'Pay now',
                gradient: true,
                onPressed: () => Get.back(result: true),
              ),
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) return;

    setState(() => _paying = true);
    final profile = Get.find<ProfileController>();
    final dup = Get.find<DuplicateController>();

    await profile.orderFunctions.addToOrderBox(
      orderEntity: OrderEntity(
        time: DateTime.now(),
        totalPrice: widget.totalPrice,
        productList: widget.productList,
      ),
    );
    await dup.cartFunctions.clearCartBox();
    if (!mounted) return;

    Get.offAll(const _OrderSuccessScreen());
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final profile = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
        children: [
          Text(
            'Choose a method',
            style: GoogleFonts.playfairDisplay(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _methods.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(() => _methodIndex = i),
                child: SoftCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _methodIndex == i
                              ? scheme.primary.withOpacity(0.1)
                              : scheme.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _methods[i].icon,
                          color: _methodIndex == i
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _methods[i].label,
                              style: GoogleFonts.manrope(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _methods[i].hint,
                              style: GoogleFonts.manrope(
                                fontSize: 12.5,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _methodIndex == i
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: _methodIndex == i
                            ? scheme.primary
                            : scheme.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: 18),
          Text(
            'Order details',
            style: GoogleFonts.playfairDisplay(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SoftCard(
            child: Column(
              children: [
                _detailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Recipient',
                  value: profile.information.name,
                ),
                const Divider(height: 22),
                _detailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: widget.addressDetail,
                ),
                const Divider(height: 22),
                _detailRow(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Items',
                  value: '${widget.productList.length} pieces',
                ),
                const Divider(height: 22),
                _detailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: '${DateTime.now().day.toString().padLeft(2, '0')}.'
                      '${DateTime.now().month.toString().padLeft(2, '0')}.'
                      '${DateTime.now().year}',
                ),
                const Divider(height: 22),
                Row(
                  children: [
                    Text('Total',
                        style: GoogleFonts.manrope(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    PriceText(
                      price: widget.totalPrice,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surfaceVariant.withOpacity(0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This is a demo checkout — no real charge will be made.',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: GlowButton(
          label: _paying
              ? 'Processing…'
              : 'Pay \$${widget.totalPrice}',
          gradient: true,
          loading: _paying,
          onPressed: _pay,
        ),
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 10),
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.manrope(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------- success

class _OrderSuccessScreen extends StatelessWidget {
  const _OrderSuccessScreen();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 60,
                color: scheme.primary,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.4, 0.4),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 700.ms,
                )
                .fadeIn(duration: 300.ms),
            const SizedBox(height: 30),
            Text(
              'Order placed',
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.3),
            const SizedBox(height: 12),
            Text(
              'Thank you — your glow is on its way.\n'
              'You can track every step in Orders.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 15,
                height: 1.6,
                color: scheme.onSurfaceVariant,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 40),
            GlowButton(
              label: 'Continue shopping',
              gradient: true,
              onPressed: () => Get.offAll(const RootScreen(index: 0)),
            ).animate().fadeIn(delay: 550.ms),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.offAll(const RootScreen(index: 3)),
              child: const Text('Back to profile'),
            ),
          ],
        ),
      ),
    );
  }
}
