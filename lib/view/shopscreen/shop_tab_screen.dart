import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../configs/app.dart';
import '../../configs/configs.dart';
import '../../model/controllers/home_controller.dart';
import '../../model/tools/jsonparse/home_content.dart';
import '../../model/tools/jsonparse/product_parse.dart';
import '../homescreen/homedetails_screen/detail_screen.dart';
import '../homescreen/search_screen/serach_screen.dart';
import '../widgets/design/design.dart';

/// Set this before jumping to the Shop tab (rootTab.value = 1) to
/// preselect a category coming from the Home screen.
final ValueNotifier<String?> shopCategoryRequest = ValueNotifier<String?>(null);

/// The Shop tab — catalogue browsing with category filter and sorting.
class ShopTabScreen extends StatefulWidget {
  const ShopTabScreen({super.key});

  @override
  State<ShopTabScreen> createState() => _ShopTabScreenState();
}

class _ShopTabScreenState extends State<ShopTabScreen>
    with AutomaticKeepAliveClientMixin {
  List<ProductEntity> _all = [];
  List<CategoryItem> _categories = [];
  bool _loading = true;
  String? _selectedCategory;

  void _onCategoryRequest() {
    final requested = shopCategoryRequest.value;
    if (requested != null && mounted) {
      setState(() => _selectedCategory = requested);
      shopCategoryRequest.value = null;
    }
  }

  @override
  void initState() {
    super.initState();
    shopCategoryRequest.addListener(_onCategoryRequest);
    final initial = shopCategoryRequest.value;
    if (initial != null) {
      _selectedCategory = initial;
      shopCategoryRequest.value = null;
    }
    _load();
  }

  @override
  void dispose() {
    shopCategoryRequest.removeListener(_onCategoryRequest);
    super.dispose();
  }

  int _sortIndex = 0;

  static const _sortLabels = ['Featured', 'Price ↑', 'Price ↓', 'Top rated'];

  @override
  bool get wantKeepAlive => true;

  Future<void> _load() async {
    final repo = Get.find<HomeController>().homeRepository;
    final products = await repo.getProducts();
    final categories = await repo.getCategories();
    if (!mounted) return;
    setState(() {
      _all = products;
      _categories = categories;
      _loading = false;
    });
  }

  List<ProductEntity> get _visible {
    var list = List<ProductEntity>.from(_all);
    if (_selectedCategory != null) {
      list = list
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
    switch (_sortIndex) {
      case 1:
        list.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case 2:
        list.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case 3:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        list.sort((a, b) {
          final f = (b.isFeatured ? 1 : 0) - (a.isFeatured ? 1 : 0);
          if (f != 0) return f;
          return b.rating.compareTo(a.rating);
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    App.init(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop', style: AppText.h2b),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: scheme.onSurface),
            onPressed: () => Get.to(() => const SearchScreen()),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                PillChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: 8),
                ..._categories.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PillChip(
                      label: c.name,
                      icon: c.icon,
                      selected: _selectedCategory == c.name,
                      onTap: () => setState(() => _selectedCategory = c.name),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _sortLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => TextChip(
                label: _sortLabels[i],
                selected: _sortIndex == i,
                onTap: () => setState(() => _sortIndex = i),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const _ShopSkeleton()
                : _visible.isEmpty
                    ? EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Nothing here yet',
                        message:
                            'We couldn\'t find products in this category.',
                        actionLabel: 'Show everything',
                        onAction: () => setState(() {
                          _selectedCategory = null;
                          _sortIndex = 0;
                        }),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.56,
                        ),
                        itemCount: _visible.length,
                        itemBuilder: (context, i) {
                          final product = _visible[i];
                          return FavProductCard(
                            key: ValueKey(product.id),
                            product: product,
                            onTap: () => Get.to(
                              DetailScreen(productEntity: product),
                            ),
                          ).animate(delay: Duration(milliseconds: 40 * i));
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

/// Sort chip — slimmer than [PillChip].
class TextChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const TextChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ShopSkeleton extends StatelessWidget {
  const _ShopSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 14,
        childAspectRatio: 0.56,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ShimmerBox(radius: 20),
          ),
          SizedBox(height: 10),
          ShimmerBox(width: 70, height: 10, radius: 5),
          SizedBox(height: 6),
          ShimmerBox(width: 140, height: 12, radius: 6),
        ],
      ),
    );
  }
}
