import 'package:flutter/material.dart';

import 'app_core_theme.dart';

/// Semantic palette of the malkiab design system.
/// Access the active brightness' palette via [AppTheme.c].
class AppTheme {
  static final AppCoreTheme _core = AppCoreTheme(
    primary: const Color(0xFFB76E79), // rose
    primaryLight: const Color(0xFFF6E7E4), // blush
    primaryDark: const Color(0xFF8E4E59), // deep rose
    accent: const Color(0xFFD9B98C), // champagne
    accentLight: const Color(0xFFF3E7D3),
    accentDark: const Color(0xFFB99A6C),
    shadow: const Color(0x245B3A42),
    shadowSub: const Color(0x145B3A42),
    textSub: const Color(0xFF8C7377),
  );

  /// Light palette — cream, rose, champagne, espresso.
  static AppCoreTheme light = _core.copyWith(
    background: Colors.white,
    backgroundSub: const Color(0xFFF7EDEA),
    scaffold: const Color(0xFFFAF5F2),
    scaffoldDark: const Color(0xFFFDF9F7),
    text: const Color(0xFF3B2B30),
    textSub2: const Color(0x403B2B30),
  );

  /// Dark palette — deep plum with rose & gold pops.
  static AppCoreTheme dark = _core.copyWith(
    background: const Color(0xFF241B1F),
    backgroundSub: const Color(0xFF33262B),
    scaffold: const Color(0xFF171214),
    scaffoldDark: const Color(0xFF120E10),
    primary: const Color(0xFFD98E94),
    primaryLight: const Color(0xFF33262B),
    primaryDark: const Color(0xFFB76E79),
    accent: const Color(0xFFE5CFA8),
    text: const Color(0xFFF5E9E7),
    textSub: const Color(0xFFB39BA1),
    textSub2: const Color(0x40F5E9E7),
    shadow: const Color(0x40000000),
    shadowSub: const Color(0x33000000),
  );

  static AppCoreTheme? c;

  /// Call from `App.init(context)` after the theme is resolvable.
  static init(BuildContext context) {
    c = isDark(context) ? dark : light;
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
