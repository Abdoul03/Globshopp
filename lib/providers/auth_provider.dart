import 'package:flutter/material.dart';
import 'package:globshopp/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  bool _loading = false;
  String? _lastError;
  String? get lastError => _lastError;
  bool get loading => _loading;

  AuthProvider([AuthRepository? repo]) : _repo = repo ?? AuthRepository();

  Future<bool> login(String username, String password) async {
    _loading = true;
    _lastError = null;
    notifyListeners();
    try {
      final ok = await _repo.login(username, password);
      return ok;
    } catch (e) {
      var msg = e.toString();
      // If the exception string is like 'Exception: <message>' strip the prefix
      const prefix = 'Exception: ';
      if (msg.startsWith(prefix)) msg = msg.substring(prefix.length);
      _lastError = msg;
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
