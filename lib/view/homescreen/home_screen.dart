import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/app.dart';
import '../../configs/configs.dart';
import '../../model/controllers/home_controller.dart';
import '../../model/controllers/theme_controller.dart';
import '../../model/tools/jsonparse/home_content.dart';
import '../rootscreen/root.dart';
import '../shopscreen/shop_tab_screen.dart';
import '../widgets/design/design.dart';
import 'bloc/home_bloc.dart';
import 'homedetails_screen/detail_screen.dart';
import 'search_screen/serach_screen.dart';
import 'shop_screen/shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  HomeBloc? _bloc;
  int _bannerIndex = 0;

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _openCategory(String category) {
    shopCategoryRequest.value = category;
    rootTab.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    App.init(context);
    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc(
            homeRepository: Get.find<HomeController>().homeRepository);
        bloc.add(HomeStart());
        _bloc = bloc;
        return bloc;
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            return _HomeContent(
              state: state,
              greeting: _greeting,
              bannerIndex: _bannerIndex,
              onBannerChanged: (i) => _bannerIndex = i,
              onRetry: () => _bloc?.add(HomeStart()),
              onCategory: _openCategory,
            );
          }
          if (state is HomeError) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: EmptyState(
                    icon: Icons.wifi_off_rounded,
                    title: 'Something went wrong',
                    message: 'We couldn’t load the latest edit.',
                    actionLabel: 'Retry',
                    onAction: () => _bloc?.add(HomeStart()),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(body: _HomeSkeleton());
        },
      ),
    );
  }
}

// ---------------------------------------------------------------- content

class _HomeContent extends StatelessWidget {
  final HomeSuccess state;
  final String greeting;
  final int bannerIndex;
  final ValueChanged<int> onBannerChanged;
  final VoidCallback onRetry;
  final ValueChanged<String> onCategory;

  const _HomeContent({
    required this.state,
    required this.greeting,
    required this.bannerIndex,
    required this.onBannerChanged,
    required this.onRetry,
    required this.onCategory,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();
    final products = state.productList;
    final trending = [...products]..sort((a, b) => b.rating.compareTo(a.rating));
    final bestsellers = products.reversed.take(6).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppStrings.brandName,
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => Get.to(() => const SearchScreen()),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Theme',
            onPressed: themeController.toggleTheme,
            icon: Obx(
              () => Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => onRetry(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 120),
          children: [
            // Greeting
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Today’s edit',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

            // Fake search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: GestureDetector(
                onTap: () => Get.to(() => const SearchScreen()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceVariant.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          size: 20, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 10),
                      Text(
                        'Search shades, brands, moods…',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                itemCount: state.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final c = state.categories[i];
                  return GestureDetector(
                    onTap: () => onCategory(c.name),
                    child: Column(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withOpacity(0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(c.icon, color: scheme.primary, size: 24),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          c.name,
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Hero carousel
            if (state.banners.isNotEmpty) ...[
              const SizedBox(height: 6),
              CarouselSlider(
                options: CarouselOptions(
                  height: 210,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.22,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  onPageChanged: (i, _) => onBannerChanged(i),
                ),
                items: [
                  for (final b in state.banners)
                    Builder(
                      builder: (context) => _BannerCard(banner: b),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  state.banners.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: bannerIndex == i ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: bannerIndex == i
                          ? scheme.primary
                          : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],

            // Trending rail
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Trending now',
                actionLabel: 'See all',
                onAction: () => Get.to(() => ShopScreen(
                    title: 'Trending now', productList: trending)),
              ),
            ),
            SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: trending.length.clamp(0, 10),
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final p = trending[i];
                  return SizedBox(
                    width: 178,
                    child: FavProductCard(
                      product: p,
                      onTap: () =>
                          Get.to(() => DetailScreen(productEntity: p)),
                    ),
                  );
                },
              ),
            ),

            // Collections
            if (state.collections.isNotEmpty) ...[
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Curated for you',
                  actionLabel: 'Explore',
                  onAction: () => Get.to(() => SearchScreen(
                      initialQuery: state.collections.first.keyWord)),
                ),
              ),
              SizedBox(
                height: 178,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.collections.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => _CollectionCard(
                    collection: state.collections[i],
                    onTap: () => Get.to(() => SearchScreen(
                        initialQuery: state.collections[i].keyWord)),
                  ),
                ),
              ),
            ],

            // Bestsellers
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Bestsellers',
                actionLabel: 'See all',
                onAction: () => Get.to(() =>
                    ShopScreen(title: 'Bestsellers', productList: products)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.66,
                ),
                itemCount: bestsellers.length,
                itemBuilder: (context, i) {
                  final p = bestsellers[i];
                  return FavProductCard(
                    product: p,
                    onTap: () =>
                        Get.to(() => DetailScreen(productEntity: p)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- pieces

class _BannerCard extends StatelessWidget {
  final BannerItem banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProductImage(url: banner.imageUrl, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.72),
                  Colors.black.withOpacity(0.15),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.88),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Shop ${banner.category}',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final CollectionItem collection;
  final VoidCallback onTap;
  const _CollectionCard({required this.collection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductImage(url: collection.imageUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      collection.subtitle,
                      style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- skeleton

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const ShimmerBox(radius: 12, height: 34, width: 180),
          const SizedBox(height: 14),
          const ShimmerBox(radius: 100, height: 50),
          const SizedBox(height: 24),
          Row(
            children: List.generate(
              5,
              (i) => const Padding(
                padding: EdgeInsets.only(right: 16),
                child: ShimmerBox(radius: 100, height: 54, width: 54),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const ShimmerBox(radius: 24, height: 210),
          const SizedBox(height: 24),
          const ShimmerBox(radius: 12, height: 24, width: 150),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: ShimmerBox(radius: 20, height: 280)),
              SizedBox(width: 14),
              Expanded(child: ShimmerBox(radius: 20, height: 280)),
            ],
          ),
        ],
      ),
    );
  }
}
