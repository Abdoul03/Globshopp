import 'package:flutter/material.dart';
import 'package:globshopp/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  bool _loading = false;
  bool get loading => _loading;

  AuthProvider([AuthRepository? repo]) : _repo = repo ?? AuthRepository();

  Future<bool> login(String username, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final ok = await _repo.login(username, password);
      return ok;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
