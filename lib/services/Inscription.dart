import 'dart:convert';

import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:http/http.dart' as http;

class Inscription {
  Future<String?> registerCommercant(Commercant commercant) async {
    try {
      final response = await http.post(
        Uri.parse("${Constant.remoteUrl}/auth/commercant/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(commercant.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Inscription réussie";
      } else {
        final error = jsonDecode(response.body);
        return "Erreur: ${error['message'] ?? response.body}";
      }
    } catch (e) {
      return "Erreur réseau: $e";
    }
  }

  Future<String?> registerFournisseur(Fournisseur fournisseur) async {
    try {
      final response = await http.post(
        Uri.parse("${Constant.remoteUrl}/auth/fournisseur/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fournisseur.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Inscription réussie";
      } else {
        final error = jsonDecode(response.body);
        return "Erreur: ${error['message'] ?? response.body}";
      }
    } catch (e) {
      return "Erreur réseau: $e";
    }
  }
}
