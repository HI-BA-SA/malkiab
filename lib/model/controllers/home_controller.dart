import 'package:get/get.dart';

import '../../viewmodel/home/homedatasource/mock_home_source.dart';
import '../../viewmodel/home/homerepository/home_repo.dart';

class HomeController extends GetxController {
  final HomeRepository homeRepositoryInstance =
      HomeRepository(dataSource: MockHomeDataSource());
  HomeRepository get homeRepository => homeRepositoryInstance;
}
