import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../configs/app.dart';
import '../../../model/controllers/profile_controller.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../rootscreen/root.dart';
import '../../widgets/design/design.dart';
import '../../homescreen/homedetails_screen/detail_screen.dart';
import 'bloc/favorite_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteBloc? _bloc;

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: BlocProvider(
        create: (context) {
          final bloc = FavoriteBloc();
          bloc.add(FavoriteStart());
          _bloc = bloc;
          return bloc;
        },
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteSuccess) {
              return _FavoriteGrid(
                products: state.productList,
                onRemove: () => _bloc?.add(FavoriteStart()),
              );
            }
            if (state is FavoriteEmpty) {
              return Center(
                child: EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'No favourites yet',
                  message:
                      'Tap the heart on anything you love — it will wait for you here.',
                  actionLabel: 'Browse the edit',
                  onAction: () => rootTab.value = 1,
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

class _FavoriteGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final VoidCallback onRemove;
  const _FavoriteGrid({required this.products, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final profileFunctions =
        Get.find<ProfileController>().profileFunctions;
    final scheme = Theme.of(context).colorScheme;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.66,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        return ProductCard(
          product: p,
          isFavorite: true,
          onTap: () => Get.to(() => DetailScreen(productEntity: p)),
          onFavorite: () async {
            await profileFunctions.removeFavorite(productEntity: p);
            Get.snackbar(
              'Removed',
              '${p.name} left your favourites',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(12),
              backgroundColor: scheme.primary,
              colorText: Colors.white,
            );
            onRemove();
          },
        );
      },
    );
  }
}
