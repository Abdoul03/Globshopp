import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/model/participation.dart';
import 'package:globshopp/services/apiService.dart';

class CommandeGroupeeService {
  final storage = FlutterSecureStorage();
  final Apiservice _apiservice = Apiservice();

  Future<CommandeGroupee> createGroupOrder(
    int produitId,
    DateTime deadline,
    Participation paticipation,
  ) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "POST",
        "/commandeGroupee/create/$produitId?deadline=${deadline.toIso8601String()}",
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CommandeGroupee.fromJson(data);
      } else {
        throw Exception('Échec de creation de la commande groupée ');
      }
    } catch (e) {
      throw Exception("Erreur lors de la creation de la commande groupée : $e");
    }
  }
}
