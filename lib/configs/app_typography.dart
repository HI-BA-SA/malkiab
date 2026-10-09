import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale of the malkiab design system.
///
/// Display / headings: **Playfair Display** (editorial serif)
/// Body / UI:          **Manrope** (clean grotesque)
class AppText {
  AppText._();

  // Display / headings — Playfair Display
  static TextStyle? display;
  static TextStyle? h1;
  static TextStyle? h1b;
  static TextStyle? h2;
  static TextStyle? h2b;
  static TextStyle? h3;
  static TextStyle? h3b;

  // Body — Manrope
  static TextStyle? b1;
  static TextStyle? b1b;
  static TextStyle? b2;
  static TextStyle? b2b;

  // Labels — Manrope
  static TextStyle? l1;
  static TextStyle? l1b;
  static TextStyle? l2;
  static TextStyle? l2b;

  // Buttons — Manrope
  static TextStyle? btn;

  static void init() {
    TextStyle playfair(double size, FontWeight weight,
            {double? height, double? spacing}) =>
        GoogleFonts.playfairDisplay(
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: spacing,
        );

    TextStyle manrope(double size, FontWeight weight,
            {double? height, double? spacing}) =>
        GoogleFonts.manrope(
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: spacing,
        );

    display = playfair(34, FontWeight.w600, height: 1.15, spacing: -0.5);
    h1 = playfair(28, FontWeight.w600, height: 1.2, spacing: -0.3);
    h1b = playfair(28, FontWeight.w700, height: 1.2, spacing: -0.3);
    h2 = playfair(22, FontWeight.w600, height: 1.25);
    h2b = playfair(22, FontWeight.w700, height: 1.25);
    h3 = playfair(18, FontWeight.w600, height: 1.3);
    h3b = playfair(18, FontWeight.w700, height: 1.3);

    b1 = manrope(16, FontWeight.w400, height: 1.5);
    b1b = manrope(16, FontWeight.w700, height: 1.5);
    b2 = manrope(14, FontWeight.w400, height: 1.45);
    b2b = manrope(14, FontWeight.w700, height: 1.45);

    l1 = manrope(13, FontWeight.w500, height: 1.4, spacing: 0.1);
    l1b = manrope(13, FontWeight.w700, height: 1.4, spacing: 0.1);
    l2 = manrope(11, FontWeight.w600, height: 1.35, spacing: 0.6);
    l2b = manrope(11, FontWeight.w800, height: 1.35, spacing: 0.6);

    btn = manrope(15, FontWeight.w700, height: 1.2, spacing: 0.2);
  }
}
