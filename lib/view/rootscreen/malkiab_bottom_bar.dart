import 'dart:ui';

import 'package:flutter/material.dart';


/// Frosted-glass bottom navigation with an animated pill indicator
/// and a live cart badge.
class MalkiabBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final int cartCount;

  const MalkiabBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          decoration: BoxDecoration(
            color: scheme.surface.withOpacity(0.82),
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: Row(
            children: [
              _item(context, 0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _item(context, 1, Icons.storefront_rounded,
                  Icons.storefront_outlined, 'Shop'),
              _item(context, 2, Icons.shopping_bag_rounded,
                  Icons.shopping_bag_outlined, 'Cart', badge: cartCount),
              _item(context, 3, Icons.person_rounded, Icons.person_outline,
                  'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int index,
    IconData filled,
    IconData outlined,
    String label, {
    int badge = 0,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final selected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: selected ? 18 : 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? scheme.primary.withOpacity(0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      selected ? filled : outlined,
                      size: 23,
                      color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                    if (badge > 0)
                      Positioned(
                        top: -5,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: scheme.surface, width: 1.5),
                          ),
                          child: Text(
                            badge > 99 ? '99+' : '$badge',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: scheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
