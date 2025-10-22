import 'package:globshopp/services/authentification.dart';

class AuthRepository {
  final Authentification _service;

  AuthRepository([Authentification? service])
    : _service = service ?? Authentification();

  Future<bool> login(String username, String password) =>
      _service.connexion(username, password);
}
