import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../model/controllers/profile_controller.dart';
import '../../../model/tools/entities/AddressEntity/address_entity.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../profilescreen/address_screen/address_screen.dart';
import '../../profilescreen/auth_screen/authentication_screen.dart';
import '../../widgets/address_sheet.dart';
import '../../widgets/design/design.dart';
import '../payment_screen/payment_screen.dart';
import 'bloc/checkout_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  final List<ProductEntity> productList;
  final String totalPrice;

  const CheckoutScreen(
      {super.key, required this.productList, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutBloc? _bloc;
  List<AddressEntity> _addresses = [];
  AddressEntity? _selected;
  int _deliveryIndex = 0;

  static const _deliveryOptions = [
    (label: 'Standard', hint: '2–4 days', fee: 0.0),
    (label: 'Express', hint: '1–2 days', fee: 9.9),
  ];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    final list = await Get.find<ProfileController>()
        .addressFunctions
        .getAddressList();
    if (!mounted) return;
    setState(() {
      _addresses = list;
      if (_selected == null && list.isNotEmpty) {
        _selected = list.first;
      } else if (_selected != null &&
          !list.any((a) => a.postalCode == _selected!.postalCode)) {
        _selected = list.isNotEmpty ? list.first : null;
      }
    });
  }

  double get _subtotal => double.tryParse(widget.totalPrice) ?? 0;
  double get _deliveryFee => _deliveryOptions[_deliveryIndex].fee;
  double get _total => _subtotal + _deliveryFee;

  Future<void> _openAddressSheet() async {
    final entity = await showAddressSheet();
    if (entity == null) return;
    _bloc ??= CheckoutBloc();
    _bloc!.add(CheckoutSaveAddress(entity));
    await _loadAddresses();
    setState(() => _selected = entity);
  }

  void _showLoginSheet() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_outline_rounded,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Sign in to continue',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You need an account to place this order.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    fontSize: 13.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              GlowButton(
                label: 'Sign in',
                gradient: true,
                onPressed: () {
                  Get.back();
                  Get.to(() => const AuthenticationScreen());
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: Get.back,
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) {
        final bloc = CheckoutBloc();
        _bloc = bloc;
        bloc.add(CheckoutStart());
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
          children: [
            // -------------------------------------------------- address
            SectionHeader(
              title: 'Shipping address',
              actionLabel: _addresses.isEmpty ? null : 'Manage',
              onAction: () =>
                  Get.to(() => const AddressScreen())?.then((_) => _loadAddresses()),
            ),
            const SizedBox(height: 10),
            if (_addresses.isEmpty)
              SoftCard(
                child: Column(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 34, color: scheme.primary),
                    const SizedBox(height: 10),
                    Text(
                      'No saved addresses yet',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add where your glow should land.',
                      style: GoogleFonts.manrope(
                          fontSize: 13, color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 14),
                    GlowButton(
                      label: 'Add address',
                      icon: Icons.add_rounded,
                      onPressed: _openAddressSheet,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  for (final a in _addresses)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = a),
                        child: SoftCard(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(
                                _selected?.postalCode == a.postalCode
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: _selected?.postalCode == a.postalCode
                                    ? scheme.primary
                                    : scheme.outline,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          a.addressName,
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          a.country,
                                          style: GoogleFonts.manrope(
                                            fontSize: 11.5,
                                            color: scheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${a.addressDetail}, ${a.state} ${a.postalCode}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        color: scheme.onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _openAddressSheet,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add another address'),
                    ),
                  ),
                ],
              ),

            // -------------------------------------------------- delivery
            const SizedBox(height: 14),
            const SectionHeader(title: 'Delivery method'),
            const SizedBox(height: 10),
            Row(
              children: [
                for (var i = 0; i < _deliveryOptions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _deliveryIndex = i),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _deliveryIndex == i
                              ? scheme.primary.withOpacity(0.08)
                              : scheme.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _deliveryIndex == i
                                ? scheme.primary
                                : scheme.outlineVariant,
                            width: _deliveryIndex == i ? 1.6 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _deliveryOptions[i].label,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: _deliveryIndex == i
                                    ? scheme.primary
                                    : scheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _deliveryOptions[i].hint,
                              style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _deliveryOptions[i].fee == 0
                                  ? 'Free'
                                  : '+\$${_deliveryOptions[i].fee}',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: _deliveryOptions[i].fee == 0
                                    ? scheme.primary
                                    : scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // -------------------------------------------------- summary
            const SizedBox(height: 26),
            const SectionHeader(title: 'Your order'),
            const SizedBox(height: 10),
            SoftCard(
              child: Column(
                children: [
                  // item avatars
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ProductImage(
                          url: widget.productList[i].imageUrl,
                          width: 52,
                          height: 52,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.productList.length} items',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: 26),
                  _summaryRow('Subtotal', PriceText(price: widget.totalPrice)),
                  const SizedBox(height: 8),
                  _summaryRow(
                    'Delivery',
                    _deliveryFee == 0
                        ? Text(
                            'Complimentary',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                          )
                        : PriceText(price: '$_deliveryFee'),
                  ),
                  const Divider(height: 26),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      PriceText(
                        price: '$_total',
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
          ],
        ),

        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: GlowButton(
            label: 'Continue to payment — \$${_total.toStringAsFixed(2)}',
            gradient: true,
            onPressed: () {
              final loggedIn =
                  Get.find<ProfileController>().islogin;
              if (!loggedIn) {
                _showLoginSheet();
                return;
              }
              if (_selected == null) {
                Get.snackbar(
                  'Address required',
                  'Select or add a shipping address first.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12),
                  backgroundColor: scheme.primary,
                  colorText: Colors.white,
                );
                return;
              }
              Get.to(() => PaymentScreen(
                    totalPrice: _total.toStringAsFixed(2),
                    productList: widget.productList,
                    addressDetail:
                        '${_selected!.addressDetail}, ${_selected!.state}, '
                        '${_selected!.country}',
                  ));
            },
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, Widget value) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 14)),
        const Spacer(),
        value,
      ],
    );
  }
}
