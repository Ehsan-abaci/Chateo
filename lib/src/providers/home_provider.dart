import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int navbarIndex = 0;

  init() => navbarIndex = 0;

  changeIndex(int index) {
    navbarIndex = index;
    notifyListeners();
  }
}
