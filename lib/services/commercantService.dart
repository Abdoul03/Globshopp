import 'dart:convert';

import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/services/apiService.dart';

class CommercantService {
  final Apiservice _apiservice = Apiservice();

  Future<Commercant> getCommercant(int commercantId) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/commercant/$commercantId",
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Commercant.fromJson(data);
      } else {
        throw Exception('Échec du chargement du commerçant');
      }
    } catch (e) {
      throw Exception("Erreur lors de la recuperation du commerçant : $e");
    }
  }

  Future<Commercant> updateCommercant(int commercantId, Map<String, dynamic> body) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        'PUT',
        '/commercant/$commercantId',
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Commercant.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Commerçant introuvable');
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        final msg = response.body.isNotEmpty ? response.body : 'Requête invalide';
        throw Exception(msg);
      } else {
        throw Exception('Échec de la mise à jour (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du commerçant : $e');
    }
  }
}
