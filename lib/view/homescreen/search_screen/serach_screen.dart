import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../model/controllers/home_controller.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../widgets/design/design.dart';
import '../homedetails_screen/detail_screen.dart';
import 'bloc/search_bloc.dart';

const _popularBrands = [
  'dior',
  'benefit',
  'clinique',
  'colourpop',
  'covergirl',
  'stila',
  'anna sui',
  'almay',
];

const _trendingTags = [
  'Lips',
  'Glow',
  'Mascara',
  'Serum',
  'Blush',
  'Rose',
  'Nude',
  'SPF',
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery = ''});
  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc? _bloc;
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery);

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bloc?.add(SearchStart(searchKeyWord: widget.initialQuery));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc?.close();
    super.dispose();
  }

  void _search(String keyword) {
    final key = keyword.trim();
    if (key.isEmpty) return;
    _bloc?.add(SearchStart(searchKeyWord: key));
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: AppBar(
        title: _SearchField(
          controller: _controller,
          onSubmitted: _search,
        ),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = SearchBloc(
              homeRepository:
                  Get.find<HomeController>().homeRepository);
          bloc.add(InitialSearchScreen());
          _bloc = bloc;
          return bloc;
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchSuccess) {
              return _Results(
                products: state.productList,
                query: _controller.text,
              );
            }
            if (state is SearchEmptyScreen) {
              return Center(
                child: EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No matches',
                  message:
                      'Nothing for “${_controller.text.trim()}” yet — try another shade or brand.',
                  actionLabel: 'Clear search',
                  onAction: () {
                    _controller.clear();
                    _bloc?.add(InitialSearchScreen());
                  },
                ),
              );
            }
            if (state is SearchError) {
              return Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Search failed',
                  message: 'Something interrupted the search.',
                  actionLabel: 'Try again',
                  onAction: () => _bloc?.add(SearchStart(
                      searchKeyWord: _controller.text.trim())),
                ),
              );
            }
            if (state is SearchLoading) {
              return const _ResultsSkeleton();
            }
            // Initial / idle: discovery
            return _Discovery(onPick: _search);
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- field

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _SearchField({required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.8),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              autofocus: false,
              style: GoogleFonts.manrope(fontSize: 14.5),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search shades, brands, moods…',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 14,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onSubmitted('');
              },
              child: Icon(Icons.close_rounded,
                  size: 18, color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- discovery

class _Discovery extends StatelessWidget {
  final ValueChanged<String> onPick;
  const _Discovery({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
      children: [
        Text(
          'Trending searches',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in _trendingTags)
              PillChip(
                label: tag,
                icon: Icons.trending_up_rounded,
                onTap: () => onPick(tag),
              ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          'Popular brands',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final brand in _popularBrands)
              PillChip(label: brand, onTap: () => onPick(brand)),
          ],
        ),
        const SizedBox(height: 36),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: scheme.surfaceVariant.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Icon(Icons.auto_awesome_rounded, color: scheme.primary, size: 30),
              const SizedBox(height: 10),
              Text(
                'Find the one',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Search by brand, product or the finish you’re after — '
                'satin, glow, soft matte.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13.5,
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- results

class _Results extends StatelessWidget {
  final List<ProductEntity> products;
  final String query;
  const _Results({required this.products, required this.query});

  @override
  Widget build(BuildContext context) {
    final list = products;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '${list.length} result${list.length == 1 ? '' : 's'} for “$query”',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.66,
          ),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final p = list[i];
            return FavProductCard(
              product: p,
              onTap: () => Get.to(() => DetailScreen(productEntity: p)),
            );
          },
        ),
      ],
    );
  }
}

class _ResultsSkeleton extends StatelessWidget {
  const _ResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.66,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerBox(radius: 20, height: 300),
    );
  }
}
