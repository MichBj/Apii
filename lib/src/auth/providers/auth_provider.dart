import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _userName;
  String? _rol; // 'admin' o 'vendedor'

  String? get userName => _userName;
  String? get rol => _rol;

  void login(String name, String role) {
    _userName = name;
    _rol = role;
    notifyListeners();
  }

  void logout() {
    _userName = null;
    _rol = null;
    notifyListeners();
  }
}