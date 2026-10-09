import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const fontFamily = '';

/// Soft-glam light theme — cream, rose and champagne.
final ThemeData themeLight = _base(
  brightness: Brightness.light,
  scheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB76E79),
    onPrimary: Colors.white,
    secondary: Color(0xFFD9B98C),
    onSecondary: Color(0xFF3B2B30),
    error: Color(0xFFC1543D),
    onError: Colors.white,
    background: Color(0xFFFAF5F2),
    onBackground: Color(0xFF3B2B30),
    surface: Colors.white,
    onSurface: Color(0xFF3B2B30),
    surfaceVariant: Color(0xFFF6E7E4),
    onSurfaceVariant: Color(0xFF8C7377),
    outline: Color(0xFFE8D8D4),
    outlineVariant: Color(0xFFF1E4E1),
  ),
  scaffold: const Color(0xFFFAF5F2),
  blush: const Color(0xFFF6E7E4),
  text: const Color(0xFF3B2B30),
  textSub: const Color(0xFF8C7377),
);

/// Soft-glam dark theme — deep plum with rose & gold pops.
final ThemeData themeDark = _base(
  brightness: Brightness.dark,
  scheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD98E94),
    onPrimary: Color(0xFF2A1418),
    secondary: Color(0xFFE5CFA8),
    onSecondary: Color(0xFF2A1418),
    error: Color(0xFFE08573),
    onError: Color(0xFF2A1418),
    background: Color(0xFF171214),
    onBackground: Color(0xFFF5E9E7),
    surface: Color(0xFF241B1F),
    onSurface: Color(0xFFF5E9E7),
    surfaceVariant: Color(0xFF33262B),
    onSurfaceVariant: Color(0xFFB39BA1),
    outline: Color(0xFF4A383F),
    outlineVariant: Color(0xFF3A2B31),
  ),
  scaffold: const Color(0xFF171214),
  blush: const Color(0xFF33262B),
  text: const Color(0xFFF5E9E7),
  textSub: const Color(0xFFB39BA1),
);

ThemeData _base({
  required Brightness brightness,
  required ColorScheme scheme,
  required Color scaffold,
  required Color blush,
  required Color text,
  required Color textSub,
}) {
  final isDark = brightness == Brightness.dark;

  TextStyle manrope(double size, FontWeight weight, Color color) =>
      GoogleFonts.manrope(fontSize: size, fontWeight: weight, color: color);

  TextStyle playfair(double size, FontWeight weight, Color color) =>
      GoogleFonts.playfairDisplay(
          fontSize: size, fontWeight: weight, color: color);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: fontFamily,
    colorScheme: scheme,
    scaffoldBackgroundColor: scaffold,
    splashColor: scheme.primary.withOpacity(0.07),
    highlightColor: Colors.transparent,
    splashFactory: InkSparkle.splashFactory,
    canvasColor: scaffold,
    focusColor: scheme.primary.withOpacity(0.06),
    hoverColor: scheme.primary.withOpacity(0.04),
    textTheme: GoogleFonts.manropeTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(bodyColor: text, displayColor: text),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: text, size: 24),
      titleTextStyle: playfair(22, FontWeight.w600, text),
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        disabledBackgroundColor: scheme.primary.withOpacity(0.4),
        disabledForegroundColor: scheme.onPrimary.withOpacity(0.7),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: manrope(15, FontWeight.w700, scheme.onPrimary),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        side: BorderSide(color: scheme.primary, width: 1.4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: manrope(15, FontWeight.w700, scheme.primary),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: manrope(15, FontWeight.w600, scheme.primary),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: blush,
      hintStyle: manrope(15, FontWeight.w400, textSub),
      labelStyle: manrope(14, FontWeight.w500, textSub),
      floatingLabelStyle: manrope(13, FontWeight.w600, scheme.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: scheme.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: scheme.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: scheme.error, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: blush,
      selectedColor: scheme.primary,
      labelStyle: manrope(14, FontWeight.w600, text),
      secondaryLabelStyle: manrope(14, FontWeight.w700, scheme.onPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      side: BorderSide.none,
      showCheckmark: false,
    ),
    cardTheme: CardTheme(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      elevation: 0,
      showDragHandle: true,
      dragHandleColor: scheme.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: playfair(22, FontWeight.w600, text),
      contentTextStyle: manrope(15, FontWeight.w400, textSub),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: text,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      contentTextStyle: manrope(14, FontWeight.w500, scaffold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled)
            ? null
            : scheme.onPrimary,
      ),
      trackColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? scheme.primary
            : blush,
      ),
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: blush,
      circularTrackColor: blush,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surface,
      selectedItemColor: scheme.primary,
      unselectedItemColor: textSub,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: text,
      textColor: text,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: scheme.primary,
      unselectedLabelColor: textSub,
      indicatorColor: scheme.primary,
      labelStyle: manrope(15, FontWeight.w700, scheme.primary),
      unselectedLabelStyle: manrope(15, FontWeight.w500, textSub),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
