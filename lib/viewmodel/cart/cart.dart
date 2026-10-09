import 'package:hive_flutter/adapters.dart';

import '../../model/tools/jsonparse/product_parse.dart';



class CartFunctions {
  final String boxName = "CartBox";
  Future<void> openCartBox() async {
    await Hive.openBox<ProductEntity>(boxName);
  }

  Future<bool> addToCart({required ProductEntity productEntity}) async {
    final box = Hive.box<ProductEntity>(boxName);
    await box.add(productEntity);
    return true;
  }

  Future<List<ProductEntity>> getProductFromHive() async {
    final box = Hive.box<ProductEntity>(boxName);
    List<ProductEntity> productList = [];
    productList = box.values.toList();

    return productList;
  }

  Future<bool> deleteProduct({required int index}) async {
    final box = Hive.box<ProductEntity>(boxName);
    await box.deleteAt(index);
    return true;
  }

  /// Number of cart entries for [productId] (each entry = one unit).
  int quantityOf({required List<ProductEntity> productList, required int productId}) =>
      productList.where((p) => p.id == productId).length;

  /// Adds one more unit of [product] to the cart.
  Future<void> incrementQuantity({required ProductEntity product}) async {
    final box = Hive.box<ProductEntity>(boxName);
    await box.add(product);
  }

  /// Removes one unit of [productId]; returns false if none present.
  Future<bool> decrementQuantity({required int productId}) async {
    final box = Hive.box<ProductEntity>(boxName);
    final index = box.values.toList().indexWhere((p) => p.id == productId);
    if (index == -1) return false;
    await box.deleteAt(index);
    return true;
  }

  /// Removes every entry of [productId] (full delete from bag).
  Future<bool> removeProduct({required int productId}) async {
    final box = Hive.box<ProductEntity>(boxName);
    final keys = box.toMap().entries
        .where((e) => e.value.id == productId)
        .map((e) => e.key)
        .toList();
    for (final key in keys) {
      await box.delete(key);
    }
    return true;
  }

  String calculateTotalPrice({required List<ProductEntity> productList}) {
    double equ = 0;
    String result;
    for (var element in productList) {
      equ = equ + double.parse(element.price);
    }
    result = equ.toString();
    return result;
  }

  Future<bool> clearCartBox() async {
    final box = Hive.box<ProductEntity>(boxName);
    await box.clear();
    return true;
  }
}
