import '../../../model/tools/jsonparse/home_content.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../homedatasource/home_source.dart';

class HomeRepository implements HomeDataSource {
  final HomeDataSource dataSource;

  HomeRepository({required this.dataSource});

  @override
  Future<List<ProductEntity>> getProducts() => dataSource.getProducts();

  @override
  Future<List<ProductEntity>> getProductsWithKeyWord(
          {required String keyWord}) =>
      dataSource.getProductsWithKeyWord(keyWord: keyWord);

  @override
  Future<List<BannerItem>> getBanners() => dataSource.getBanners();

  @override
  Future<List<CategoryItem>> getCategories() => dataSource.getCategories();

  @override
  Future<List<CollectionItem>> getCollections() => dataSource.getCollections();
}
