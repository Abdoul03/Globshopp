import 'dart:convert';

import 'package:globshopp/model/categorie.dart';
import 'package:globshopp/services/apiService.dart';

class CategorieService {
  final Apiservice _apiservice = Apiservice();

  Future<List<Categorie>> getAllCategoeri() async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/categorie",
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Categorie.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des produits');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des categories : $e');
    }
  }
}
