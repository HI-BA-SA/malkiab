import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/app.dart';
import '../../model/controllers/duplicate_controller.dart';
import '../../model/controllers/initial_controller.dart';
import '../cartscreen/cart_screen.dart';
import '../homescreen/home_screen.dart';
import '../profilescreen/profile_screen.dart';
import '../shopscreen/shop_tab_screen.dart';
import 'malkiab_bottom_bar.dart';

/// Global tab switcher — lets any screen jump to a tab (e.g. empty cart → Shop).
final ValueNotifier<int> rootTab = ValueNotifier(0);

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.index});
  final int index;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  final duplicateController = Get.find<DuplicateController>();
  final initialController = Get.find<InitialController>();
  late int selectedIndex = widget.index;
  late final PageController pageController =
      PageController(initialPage: selectedIndex, keepPage: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    rootTab.value = selectedIndex;
    rootTab.addListener(_onRootTab);
  }

  void _onRootTab() {
    if (!mounted) return;
    if (rootTab.value != selectedIndex) {
      setState(() => selectedIndex = rootTab.value);
      pageController.jumpToPage(rootTab.value);
    }
  }

  @override
  void dispose() {
    rootTab.removeListener(_onRootTab);
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      await initialController.closeHive();
    }
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        children: const [
          HomeScreen(),
          ShopTabScreen(),
          CartScreen(),
          ProfileScreen(),
        ],
        onPageChanged: (value) => setState(() => selectedIndex = value),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: duplicateController.cartBoxListenable,
        builder: (context, box, _) => MalkiabBottomBar(
          selectedIndex: selectedIndex,
          cartCount: box.length,
          onItemSelected: (value) {
            setState(() => selectedIndex = value);
            rootTab.value = value;
            pageController.jumpToPage(value);
          },
        ),
      ),
    );
  }
}
