import 'package:flutter/material.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String category;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.category,
  });
}

class CategoryItem {
  final String name;
  final IconData icon;

  const CategoryItem({required this.name, required this.icon});
}

class CollectionItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String keyWord;

  const CollectionItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.keyWord,
  });
}
