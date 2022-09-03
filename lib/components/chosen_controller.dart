import 'package:flutter/material.dart';

class ChosenController extends ValueNotifier {
  bool _isOpened;

  ChosenController({bool isOpened = false})
      : _isOpened = isOpened, super(null);

  bool get isOpened => _isOpened;

  set isOpened(bool isOpened) {
    _isOpened = isOpened;
    notifyListeners();
  }
}
