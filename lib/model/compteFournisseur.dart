import 'dart:ffi';

import 'package:globshopp/model/enum/methodeDePayement.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:globshopp/model/transaction.dart';

class CompteFournisseur {
  int? id;
  String numero;
  double montant;
  MethodeDePayement? methodeDePayement;
  Fournisseur? fournisseur;
  List<Transaction>? transactions;

  CompteFournisseur({
    this.id,
    required this.numero,
    required this.montant,
    this.methodeDePayement,
    this.fournisseur,
    this.transactions,
  });

  // --- fromJson ---
  factory CompteFournisseur.fromJson(Map<String, dynamic> json) {
    return CompteFournisseur(
      id: json['id'],
      numero: json['numero'] ?? '',
      montant: (json['montant'] ?? 0).toDouble(),
      methodeDePayement: json['methodeDePayement'] != null
          ? MethodeDePayement.values.firstWhere(
              (e) =>
                  e.name == json['methodeDePayement'].toString().toUpperCase(),
              orElse: () => MethodeDePayement.ORANGE_MONEY,
            )
          : null,
      fournisseur: json['fournisseur'] != null
          ? Fournisseur.fromJson(json['fournisseur'])
          : null,
      transactions: (json['transactions'] as List?)
          ?.map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'montant': montant,
      'methodeDePayement': methodeDePayement?.name,
      'fournisseur': fournisseur?.toJson(),
      'transactions': transactions?.map((t) => t.toJson()).toList(),
    };
  }
}
