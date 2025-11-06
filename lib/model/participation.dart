import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/model/transaction.dart';

class Participation {
  final int? id;
  Commercant? commercant;
  CommandeGroupee? commandeGroupee;
  DateTime? data;
  int quantite;
  double montant;
  Transaction? transaction;

  Participation({
    this.id,
    this.commercant,
    this.commandeGroupee,
    this.data,
    required this.quantite,
    required this.montant,
    this.transaction,
  });

  // --- fromJson ---
  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(
      id: json['id'],
      commercant: json['commercant'] != null
          ? Commercant.fromJson(json['commercant'])
          : null,
      commandeGroupee: json['commandeGroupee'] != null
          ? CommandeGroupee.fromJson(json['commandeGroupee'])
          : null,
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      quantite: json['quantite'] ?? 0,
      montant: (json['montant'] ?? 0).toDouble(),
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commercant': commercant?.toJson(),
      'commandeGroupee': commandeGroupee?.toJson(),
      'data': data?.toIso8601String(),
      'quantite': quantite,
      'montant': montant,
      'transaction': transaction?.toJson(),
    };
  }
}
