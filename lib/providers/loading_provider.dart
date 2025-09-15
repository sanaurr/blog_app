import 'dart:developer';

import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    if (value == _isLoading) return;
    log("Loading provider: $value");
    _isLoading = value;
    notifyListeners();
  }
}
