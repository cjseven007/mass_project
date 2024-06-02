import 'package:flutter/material.dart';

class NavUseCase extends ChangeNotifier {
  int bottomNavIdx = 0;

  changeIdx(int idx) {
    bottomNavIdx = idx;
    notifyListeners();
  }
}
