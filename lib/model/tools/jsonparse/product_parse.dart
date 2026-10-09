import 'package:hive/hive.dart';

part 'product_parse.g.dart';

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String price;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final String productType;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final String brand;
  @HiveField(7)
  final String category;
  @HiveField(8)
  final double rating;
  @HiveField(9)
  final int reviewCount;
  @HiveField(10)
  final List<String> shades;
  @HiveField(11)
  final String badge;
  @HiveField(12)
  final bool isFeatured;
  @HiveField(13)
  final List<String> gallery;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.productType,
    required this.description,
    this.brand = '',
    this.category = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.shades = const [],
    this.badge = '',
    this.isFeatured = false,
    this.gallery = const [],
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        price: json['price']?.toString() ?? '',
        imageUrl: json['image_link'] ?? '',
        productType: json['product_type'] ?? '',
        description: json['description'] ?? '',
        brand: json['brand'] ?? '',
        category: json['category'] ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        gallery: (json['gallery'] as List?)?.cast<String>() ?? const [],
      );

  double get priceValue => double.tryParse(price) ?? 0;

  List<String> get imageGallery => [imageUrl, ...gallery];
}
