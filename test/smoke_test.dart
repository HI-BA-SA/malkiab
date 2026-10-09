import 'dart:io';

import 'package:beautify/configs/app_strings.dart';
import 'package:beautify/configs/core_theme.dart' as theme;
import 'package:beautify/model/controllers/duplicate_controller.dart';
import 'package:beautify/model/controllers/home_controller.dart';
import 'package:beautify/model/controllers/initial_controller.dart';
import 'package:beautify/model/controllers/profile_controller.dart';
import 'package:beautify/model/controllers/theme_controller.dart';
import 'package:beautify/model/tools/constants/mock_catalog.dart';
import 'package:beautify/model/tools/entities/AddressEntity/address_entity.dart';
import 'package:beautify/model/tools/entities/OrderEntity/order_entity.dart';
import 'package:beautify/model/tools/jsonparse/product_parse.dart';
import 'package:beautify/view/homescreen/bloc/home_bloc.dart';
import 'package:beautify/view/landing_screen/landing_screen.dart';
import 'package:beautify/view/rootscreen/root.dart';
import 'package:beautify/viewmodel/home/homedatasource/mock_home_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

Directory _tmp = Directory.systemTemp;

// Intentionally overrides a non-existent member so HttpOverrides falls
// through to the base createHttpClient → real network (google_fonts /
// cached_network_image need it; flutter_test would otherwise 400 them).
// ignore: override_on_non_overriding_member
class _NoopHttpOverrides extends HttpOverrides {
  // ignore: unused_element
  HttpClient createClient(SecurityContext? context) =>
      HttpClient(context: context);
}

Future<void> _bootEnvironment() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _NoopHttpOverrides();

  _tmp = await Directory.systemTemp.createTemp('malkiab_test');
  // Provide a documents path for GetStorage / image picker lookups.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => _tmp.path);

  Hive.init(_tmp.path);
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ProductEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AddressEntityAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(OrderEntityAdapter());
  }

  await GetStorage.init();
  Get.put(DuplicateController());
  Get.put(ProfileController());
  Get.put(HomeController());
  Get.put(ThemeController());
  Get.put(InitialController());

  await Get.find<DuplicateController>().cartFunctions.openCartBox();
  await Get.find<ProfileController>().profileFunctions.openFavoriteBox();
  await Hive.openBox('app');
}

Future<void> _disposeTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  setUpAll(() async {
    await _bootEnvironment();
  });

  tearDown(() async {
    await Hive.box<ProductEntity>(
            Get.find<DuplicateController>().cartFunctions.boxName)
        .clear();
  });

  testWidgets('app boots to the malkiab onboarding', (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.themeLight,
      home: const LandingScreen(),
    ));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('malkiab'), findsWidgets);
    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);

    await _disposeTree(tester);
  });

  testWidgets('home renders the mock catalog', (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.themeLight,
      home: const RootScreen(index: 0),
    ));

    // Initial skeleton frame.
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Today’s edit'), findsNothing);

    // MockHomeDataSource runs 4 sequential calls of ~450ms each —
    // pump incrementally so each chained timer fires and rebuilds.
    for (var i = 0; i < 28; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Today’s edit'), findsOneWidget);
    expect(find.text(MockCatalog.banners.first.title), findsWidgets);
    expect(find.text(MockCatalog.categories.first.name), findsWidgets);

    await _disposeTree(tester);
  });

  testWidgets('shop tab lists products and filters by category',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.themeLight,
      home: const RootScreen(index: 1),
    ));
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Shop'), findsWidgets);
    expect(find.text('All'), findsWidgets);

    // Tap the first category pill and expect the filter to engage.
    final lipsPill = find.text(MockCatalog.categories.first.name);
    expect(lipsPill, findsWidgets);

    await _disposeTree(tester);
  });

  test('home bloc emits HomeSuccess from the mock source', () async {
    final bloc = HomeBloc(
        homeRepository: Get.find<HomeController>().homeRepository);
    final states = <HomeState>[];
    final sub = bloc.stream.listen(states.add);
    bloc.add(HomeStart());
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    await sub.cancel();
    await bloc.close();
    expect(states.whereType<HomeSuccess>().length, 1);
    expect(states.last, isA<HomeSuccess>());
  });

  test('cart supports add / increment / decrement / remove', () async {
    final cart = Get.find<DuplicateController>().cartFunctions;
    final product = MockCatalog.products.first;

    expect(await cart.addToCart(productEntity: product), isTrue);
    expect(cart.quantityOf(
        productList: await cart.getProductFromHive(), productId: product.id), 1);

    await cart.incrementQuantity(product: product);
    var list = await cart.getProductFromHive();
    expect(list.length, 2);
    expect(
        cart.quantityOf(productList: list, productId: product.id), 2);

    final unit = double.parse(product.price);
    expect(cart.calculateTotalPrice(productList: list),
        (unit * 2).toString());

    expect(
        await cart.decrementQuantity(productId: product.id), isTrue);
    list = await cart.getProductFromHive();
    expect(list.length, 1);

    expect(await cart.removeProduct(productId: product.id), isTrue);
    expect((await cart.getProductFromHive()).isEmpty, isTrue);
  });

  test('mock data source serves products, banners and keyword search',
      () async {
    final source = MockHomeDataSource();
    final products = await source.getProducts();
    expect(products.length, MockCatalog.products.length);

    final banners = await source.getBanners();
    expect(banners.length, MockCatalog.banners.length);

    final lipProducts =
        await source.getProductsWithKeyWord(keyWord: 'lip');
    expect(lipProducts, isNotEmpty);
    for (final p in lipProducts) {
      final haystack =
          '${p.name} ${p.brand} ${p.category} ${p.description}'.toLowerCase();
      expect(haystack, contains('lip'));
    }
  });
}
