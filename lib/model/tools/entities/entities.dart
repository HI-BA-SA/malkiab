import 'package:flutter/widgets.dart';


class UiDuplicate {
  final defaultScroll = const BouncingScrollPhysics();
}

class UserInformation {
  final String name;
  final String userName;
  final String password;

  UserInformation(
      {required this.userName, required this.password, required this.name});
}


