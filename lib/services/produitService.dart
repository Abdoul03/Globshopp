import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/model/tokenPair.dart';
import 'package:globshopp/services/apiService.dart';
import 'package:http/http.dart' as http;

class Produitservice {
  final storage = FlutterSecureStorage();
  final Apiservice _apiservice = Apiservice();

  Future<List<Produit>> getAllProduits() async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/produits",
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Produit.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des produits');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits : $e');
    }
  }

  Future<Produit> getProduit(int id) async {
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

  Future<Produit> createProduit(Produit produit, List<File>? images) async {
    try {
      String? token = await getAccessToken();

      // Fonction interne pour envoyer la requête avec un token donné
      Future<http.StreamedResponse> _sendProduitRequest(String token) async {
        final produitJson = jsonEncode(produit.toJson());
        final request = http.MultipartRequest(
          "POST",
          Uri.parse("${Constant.remoteUrl}/produits"),
        );

        request.fields["produit"] = produitJson;

        for (var image in images!) {
          request.files.add(
            await http.MultipartFile.fromPath("images", image.path),
          );
        }

        request.headers["Authorization"] = "Bearer $token";
        return await request.send();
      }

      // Première tentative
      var response = await _sendProduitRequest(token!);
      var responseBody = await response.stream.bytesToString();

      // Si le token est expiré
      if (response.statusCode == 401) {
        final refreshed = await refreshToken();
        if (refreshed == null) {
          throw Exception('Session expirée. Veuillez vous reconnecter.');
        }

        final newToken = refreshed.accessToken;
        response = await _sendProduitRequest(newToken);
        responseBody = await response.stream.bytesToString();
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Produit créé avec succès : $responseBody");
        return Produit.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception(
          'Erreur lors de la création du produit (${response.statusCode}): $responseBody',
        );
      }
    } catch (e) {
      throw Exception("Erreur lors de la création du produit : $e");
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  Future<TokenPair?> refreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return null;

    final response = await http.post(
      Uri.parse('${Constant.remoteUrl}/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: refresh,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);
        return TokenPair(accessToken: accessToken, refreshToken: refreshToken);
      }
    }
    return null;
  }
}
