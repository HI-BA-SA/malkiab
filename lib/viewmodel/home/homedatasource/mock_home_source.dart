import '../../../model/tools/constants/mock_catalog.dart';
import '../../../model/tools/jsonparse/home_content.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import 'home_source.dart';

/// Local catalogue-backed data source. Replaces the retired
/// makeup-api.herokuapp.com backend is retired; mock serves local catalog data
/// (or a real boutique API) through [HomeRepository] when available.
class MockHomeDataSource implements HomeDataSource {
  /// Simulated network latency so loading states stay honest.
  Duration latency = const Duration(milliseconds: 450);

  Future<void> _wait() => Future.delayed(latency);

  @override
  Future<List<ProductEntity>> getProducts() async {
    await _wait();
    return MockCatalog.products;
  }

  @override
  Future<List<ProductEntity>> getProductsWithKeyWord(
      {required String keyWord}) async {
    await _wait();
    final query = keyWord.trim().toLowerCase();
    if (query.isEmpty) return MockCatalog.products;
    return MockCatalog.products
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query) ||
            p.productType.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query))
        .toList();
  }

  @override
  Future<List<BannerItem>> getBanners() async {
    await _wait();
    return MockCatalog.banners;
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    await _wait();
    return MockCatalog.categories;
  }

  @override
  Future<List<CollectionItem>> getCollections() async {
    await _wait();
    return MockCatalog.collections;
  }
}
