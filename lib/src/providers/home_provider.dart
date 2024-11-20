import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int navbarIndex = 0;

  final PageController _controller = PageController();

  PageController get controller => _controller;

  changeIndex(int index) {
    navbarIndex = index;
    notifyListeners();
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
  }
}
