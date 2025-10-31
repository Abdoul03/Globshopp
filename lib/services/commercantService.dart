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
}
