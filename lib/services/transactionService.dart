import 'dart:convert';

import 'package:globshopp/model/transaction.dart';
import 'package:globshopp/services/apiService.dart';

class Transactionservice {
  final Apiservice _apiservice = Apiservice();

  Future<List<Transaction>> getAllTransaction() async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/transaction",
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des transaction');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Transaction : $e');
    }
  }

  Future<List<Transaction>> getCommercantTransaction() async {
    try {
      final response = await _apiservice.requestWithAuthentification(
        "GET",
        "/transaction/commercant",
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des transaction');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Transaction : $e');
    }
  }
}
