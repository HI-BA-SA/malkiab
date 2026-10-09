import 'package:flutter/material.dart';

import 'app_dimensions.dart';
import 'app_theme.dart';

/// Radii, paddings, shadows and motion tokens of the design system.
abstract class UIProps {
  // Motion
  static Duration duration = const Duration(milliseconds: 280);
  static Duration duration2 = const Duration(milliseconds: 400);

  // Paddings
  static EdgeInsets? btnPadMed;
  static EdgeInsets? btnPadSm;

  // Radius
  static double radius = 16.0;
  static BorderRadius? tabRadius;
  static BorderRadius? buttonRadius;
  static BorderRadius? cardRadius;
  static BoxDecoration? borderButton;

  // Shadows
  static List<BoxShadow>? cardShadow;
  static List<BoxShadow>? floatingShadow;

  // BoxDecoration
  static BoxDecoration? boxCard;

  static init() {
    initRadius();
    initButtons();
    initShadows();
    initBoxDecorations();
  }

  static initRadius() {
    tabRadius = BorderRadius.circular(radius * 1.5); // 24
    buttonRadius = BorderRadius.circular(100); // pill
    cardRadius = BorderRadius.circular(radius * 1.5); // 24
  }

  static initButtons() {
    borderButton = BoxDecoration(
      borderRadius: buttonRadius,
      border: Border.all(
        width: 1.4,
        color: AppTheme.c!.primary!,
      ),
    );
    btnPadSm = EdgeInsets.symmetric(
      horizontal: AppDimensions.padding! * 2,
      vertical: AppDimensions.padding! * 1.0,
    );
    btnPadMed = EdgeInsets.symmetric(
      horizontal: AppDimensions.padding! * 3,
      vertical: AppDimensions.padding! * 1.5,
    );
  }

  static initShadows() {
    cardShadow = [
      BoxShadow(
        color: AppTheme.c!.shadowSub!,
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ];
    floatingShadow = [
      BoxShadow(
        color: AppTheme.c!.shadow!,
        blurRadius: 30,
        offset: const Offset(0, 14),
      ),
    ];
  }

  static initBoxDecorations() {
    boxCard = BoxDecoration(
      borderRadius: cardRadius,
      boxShadow: cardShadow,
      color: AppTheme.c!.background,
    );
  }
}
