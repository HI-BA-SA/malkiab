import 'package:flutter/material.dart';

/// The primary call-to-action: a pill button with an optional
/// rose→champagne glow gradient and loading state.
class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool loading;
  final bool gradient;
  final bool outlined;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const GlowButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
    this.loading = false,
    this.gradient = false,
    this.outlined = false,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !loading;
    final fg = outlined
        ? (color ?? scheme.primary)
        : scheme.onPrimary;

    Widget child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: outlined ? scheme.primary : scheme.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19, color: fg),
                const SizedBox(width: 8),
              ],
              Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
              )),
            ],
          );

    final decoration = outlined
        ? BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: color ?? scheme.primary, width: 1.4),
          )
        : BoxDecoration(
            color: gradient ? null : (color ?? scheme.primary),
            gradient: gradient
                ? LinearGradient(
                    colors: [
                      color ?? scheme.primary,
                      scheme.secondary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(100),
            boxShadow: enabled && !outlined
                ? [
                    BoxShadow(
                      color: (color ?? scheme.primary).withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          );

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding,
          alignment: Alignment.center,
          decoration: decoration,
          child: child,
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
