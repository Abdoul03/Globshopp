import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/model/participation.dart';
import 'package:globshopp/services/apiService.dart';

class CommandeGroupeeService {
  final storage = FlutterSecureStorage();
  final Apiservice _apiservice = Apiservice();

  Future<Participation> createGroupOrder(
    int produitId,
    DateTime deadline,
    Participation participation,
  ) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "POST",
        "/commandeGroupee/create/$produitId?deadline=${deadline.toIso8601String().split('T')[0]}",
        body: jsonEncode(participation.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Participation.fromJson(data);
      } else {
        throw Exception('Échec de creation de la commande groupée ');
      }
    } catch (e) {
      throw Exception("Erreur lors de la creation de la commande groupée : $e");
    }
  }
}
