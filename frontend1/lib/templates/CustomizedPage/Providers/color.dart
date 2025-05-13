import 'package:flutter/material.dart';

class BackgroundColorNotifier extends ChangeNotifier {
  Color _backgroundColor = Colors.white;

  Color get backgroundColor => _backgroundColor;

  void changeColor(Color newColor) {
    _backgroundColor = newColor;
    notifyListeners(); // Notify all listeners when the color changes
  }
}
