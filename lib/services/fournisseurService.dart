import 'dart:convert';

import 'package:globshopp/model/fournisseur.dart';
import 'package:globshopp/services/apiService.dart';

class FournisseurService {
  final Apiservice _apiservice = Apiservice();

  Future<List<Fournisseur>> getAllFournisseur() async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/fournisseur",
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Fournisseur.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des fournisseurs');
      }
    } catch (e) {
      throw Exception("Erreur lors de la recuperation des fournisseur : $e");
    }
  }
}
