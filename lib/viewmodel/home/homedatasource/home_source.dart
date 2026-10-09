import '../../../model/tools/jsonparse/home_content.dart';
import '../../../model/tools/jsonparse/product_parse.dart';

abstract class HomeDataSource {
  Future<List<ProductEntity>> getProducts();

  Future<List<ProductEntity>> getProductsWithKeyWord({required String keyWord});

  Future<List<BannerItem>> getBanners();

  Future<List<CategoryItem>> getCategories();

  Future<List<CollectionItem>> getCollections();
}

