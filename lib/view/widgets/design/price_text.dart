import 'package:flutter/material.dart';

/// Formats and styles money — "$26.00".
class PriceText extends StatelessWidget {
  final String price;
  final String currency;
  final TextStyle? style;
  final Color? color;

  const PriceText({
    super.key,
    required this.price,
    this.currency = r'$',
    this.style,
    this.color,
  });

  /// Formats any numeric string/number as a clean 2-decimal price.
  static String format(Object? value, {String currency = r'$'}) {
    final n = value is num ? value : (value is String ? (double.tryParse(value) ?? 0) : 0);
    return '$currency${n.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = double.tryParse(price)?.toStringAsFixed(2) ?? price;
    return Text(
      '$currency$value',
      style: style ??
          Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color ?? scheme.primary,
                fontWeight: FontWeight.w800,
              ),
    );
  }
}
