import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/model/commandeGroupee.dart';
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
      } else if (response.statusCode == 500) {
        throw Exception(response.body);
      } else {
        throw Exception('Échec de creation de la commande groupée ');
      }
    } catch (e) {
      throw Exception("Erreur lors de la creation de la commande groupée : $e");
    }
  }

  Future<Participation> JoindreUneCommande(
    int produitId,
    Participation participation,
  ) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "POST",
        "/commandeGroupee/join/$produitId",
        body: jsonEncode(participation.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Participation.fromJson(data);
      } else if (response.statusCode == 500) {
        throw Exception(response.body);
      } else {
        throw Exception('Vous ne pouvez pas rejoindre cette commande groupée ');
      }
    } catch (e) {
      throw Exception(
        "Une erreur est survenue quand vous avez essayer de rejoindre la commande groupée : $e",
      );
    }
  }

  Future<List<CommandeGroupee>> getfournisseurCommandes(int id) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/commandeGroupee/fournisseur/$id",
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CommandeGroupee.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des commandes Groupées');
      }
    } catch (e) {
      throw Exception("Erreur lors de la creation de la commande groupée : $e");
    }
  }

  // --- Commercant Endpoints Integration ---
  Future<List<CommandeGroupee>> getCommercantCommandesAll(
    int commercantId,
  ) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/commandeGroupee/commercant/$commercantId",
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Si le backend renvoie une liste JSON
        if (decoded is List) {
          return decoded
              .map((json) => CommandeGroupee.fromJson(json))
              .toList();
        }

        // Si le backend renvoie un seul objet JSON
        if (decoded is Map<String, dynamic>) {
          return [CommandeGroupee.fromJson(decoded)];
        }

        throw Exception(
          'Format de réponse inattendu pour les commandes du commerçant',
        );
      } else {
        throw Exception('Échec du chargement des commandes du commerçant');
      }
    } catch (e) {
      throw Exception(
        "Erreur lors du chargement des commandes du commerçant : $e",
      );
    }
  }

  Future<CommandeGroupee?> getCommercantCommande(int commercantId) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/commandeGroupee/commercant/$commercantId",
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CommandeGroupee.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Échec du chargement de la commande du commerçant');
      }
    } catch (e) {
      throw Exception(
        "Erreur lors du chargement de la commande du commerçant : $e",
      );
    }
  }

  Future<CommandeGroupee> getAOrderGroupe(int id) async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/commandeGroupee/$id",
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CommandeGroupee.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Commande introuvable');
      } else if (response.statusCode == 401) {
        throw Exception('Non autorisé');
      } else {
        throw Exception('Échec du chargement du détail commande');
      }
    } catch (e) {
      throw Exception("Erreur lors du chargement du détail commande : $e");
    }
  }
}
