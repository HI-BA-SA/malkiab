part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ProductEntity> productList;
  final List<BannerItem> banners;
  final List<CategoryItem> categories;
  final List<CollectionItem> collections;

  HomeSuccess({
    required this.productList,
    required this.banners,
    required this.categories,
    required this.collections,
  });
}

class HomeError extends HomeState {
}
