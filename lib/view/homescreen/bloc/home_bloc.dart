import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/tools/jsonparse/home_content.dart';
import '../../../model/tools/jsonparse/product_parse.dart';
import '../../../viewmodel/home/homerepository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  HomeBloc({required this.homeRepository}) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      try {
        if (event is HomeStart) {
          emit(HomeLoading());
          final productList = await homeRepository.getProducts();
          final banners = await homeRepository.getBanners();
          final categories = await homeRepository.getCategories();
          final collections = await homeRepository.getCollections();
          emit(HomeSuccess(
            productList: productList,
            banners: banners,
            categories: categories,
            collections: collections,
          ));
        }
      } catch (e) {
        emit(HomeError());
      }
    });
  }
}
