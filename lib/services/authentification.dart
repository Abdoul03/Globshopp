import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:http/http.dart' as http;

class Authentification {
  final storage = FlutterSecureStorage();

  Future<bool> connexion(String username, String motDePasse) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"identifiant": username, "motDePasse": motDePasse}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'jwt', value: token);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> registerCommercant(Commercant commercant) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/commercant/register"),
      headers: {"Content-Type": "application/json"},
      // body: jsonEncode(commercant.toJson()),
    );

    if (response.statusCode == 200) {
      return "Inscription réussie";
    } else {
      return "Erreur: ${response.body}";
    }
  }

  Future<String?> registerFournisseur(Fournisseurs fournisseur) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/fournisseur/register"),
      headers: {"Content-Type": "application/json"},
      // body: jsonEncode(fournisseur.toJson()),
    );

    if (response.statusCode == 200) {
      return "Inscription réussie";
    } else {
      return "Erreur: ${response.body}";
    }
  }
}
