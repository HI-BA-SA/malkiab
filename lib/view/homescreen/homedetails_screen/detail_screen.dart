import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../configs/app.dart';
import '../../../configs/configs.dart';
import '../../../model/controllers/duplicate_controller.dart';
import '../../../model/controllers/profile_controller.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../widgets/design/design.dart';
import '../../rootscreen/root.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PageController _galleryController = PageController();
  int _galleryPage = 0;
  int _shadeIndex = 0;
  bool _descExpanded = false;
  late bool _isFavorite;
  bool _adding = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = Get.find<ProfileController>()
        .profileFunctions
        .isInFavoriteBox(productEntity: widget.productEntity);
  }

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    final functions =
        Get.find<ProfileController>().profileFunctions;
    if (_isFavorite) {
      await functions.removeFavorite(productEntity: widget.productEntity);
    } else {
      await functions.addToFavorite(productEntity: widget.productEntity);
    }
    setState(() => _isFavorite = !_isFavorite);
  }

  Future<void> _addToBag() async {
    if (_adding) return;
    setState(() => _adding = true);
    final added = await Get.find<DuplicateController>()
        .cartFunctions
        .addToCart(productEntity: widget.productEntity);
    if (!mounted) return;
    setState(() => _adding = false);
    if (added) {
      final scheme = Theme.of(context).colorScheme;
      Get.showSnackbar(
        GetSnackBar(
          messageText: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${widget.productEntity.name} added to your bag',
                  style: GoogleFonts.manrope(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  rootTab.value = 2;
                },
                child: Text(
                  'View bag',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: scheme.primary,
          margin: const EdgeInsets.all(14),
          borderRadius: 16,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final p = widget.productEntity;
    final gallery = p.gallery.isNotEmpty ? p.gallery : [p.imageUrl];

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 420,
            backgroundColor: scheme.surface,
            leading: const SizedBox.shrink(),
            actions: const [SizedBox.shrink()],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _galleryController,
                    itemCount: gallery.length,
                    onPageChanged: (i) => setState(() => _galleryPage = i),
                    itemBuilder: (_, i) => ProductImage(
                      url: gallery[i],
                      fit: BoxFit.cover,
                    ),
                  ),
                  // top gradient so icons stay readable
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Colors.black38, Colors.transparent],
                      ),
                    ),
                  ),
                  // floating controls
                  Positioned.fill(
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CircleControl(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Get.back(),
                            ),
                            Row(
                              children: [
                                _CircleControl(
                                  icon: _isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: _isFavorite
                                      ? scheme.primary
                                      : scheme.onSurface,
                                  onTap: _toggleFavorite,
                                ),
                                const SizedBox(width: 8),
                                _CircleControl(
                                  icon: Icons.share_outlined,
                                  onTap: () => Share.share(
                                    '${p.name} — ${AppStrings.brandName}\n'
                                    '${p.description}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // page dots
                  if (gallery.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          gallery.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _galleryPage == i ? 20 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _galleryPage == i
                                  ? scheme.primary
                                  : Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (p.brand.isEmpty ? AppStrings.brandName : p.brand)
                                  .toUpperCase(),
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.name,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PriceText(
                        price: p.price,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RatingStars(
                        rating: p.rating,
                        count: p.reviewCount,
                      ),
                      const Spacer(),
                      if (p.badge.isNotEmpty)
                        PillChip(label: p.badge, selected: true),
                    ],
                  ),

                  // Shade selector
                  if (p.shades.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text(
                          'Shade',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          p.shades[_shadeIndex],
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < p.shades.length; i++)
                          PillChip(
                            label: p.shades[i],
                            selected: i == _shadeIndex,
                            onTap: () => setState(() => _shadeIndex = i),
                          ),
                      ],
                    ),
                  ],

                  // Description
                  const SizedBox(height: 22),
                  Text(
                    'About this piece',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _descExpanded = !_descExpanded),
                    child: Text(
                      p.description,
                      maxLines: _descExpanded ? null : 4,
                      overflow: _descExpanded
                          ? null
                          : TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 14.5,
                        height: 1.6,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (p.description.length > 160)
                    GestureDetector(
                      onTap: () =>
                          setState(() => _descExpanded = !_descExpanded),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _descExpanded ? 'Show less' : 'Read more',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  SoftCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 22, color: scheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Complimentary delivery on orders over \$50 — '
                            'arrives in 2–4 days.',
                            style: GoogleFonts.manrope(
                                fontSize: 13, height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: scheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _isFavorite ? scheme.primary : scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlowButton(
                label: _adding ? 'Adding…' : 'Add to bag — \$${p.price}',
                gradient: true,
                loading: _adding,
                onPressed: _addToBag,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _CircleControl({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white.withOpacity(0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(icon, size: 19, color: color ?? scheme.onSurface),
        ),
      ),
    );
  }
}
