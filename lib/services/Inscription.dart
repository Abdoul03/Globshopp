import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:http/http.dart' as http;

class Inscription {
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
