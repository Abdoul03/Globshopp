import 'dart:convert';
import 'dart:ffi';

import 'package:globshopp/model/produit.dart';
import 'package:globshopp/services/apiService.dart';

class Produitservice {
  final Apiservice _apiservice = Apiservice();

  Future<List<Produit>> getAllProduits() async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/produits",
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(jsonDecode(response.body));
        return data.map((json) => Produit.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des produits');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits : $e');
    }
  }

  Future<Produit> getProduit(Long id) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/produits/$id",
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Produit.fromJson(data);
      } else {
        throw Exception('Échec du chargement du produit');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du produit : $e');
    }
  }
}
