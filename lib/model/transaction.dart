import 'package:globshopp/model/compteFournisseur.dart';
import 'package:globshopp/model/enum/methodeDePayement.dart';
import 'package:globshopp/model/enum/statut.dart';
import 'package:globshopp/model/enum/transactionType.dart';
import 'package:globshopp/model/participation.dart';
import 'package:globshopp/model/wallet.dart';

class Transaction {
  final int? id;
  double montant;
  TransactionType? transactionType;
  MethodeDePayement? methodeDePayement;
  DateTime? date;
  Participation? participation;
  Wallet? wallet;
  CompteFournisseur? compteFournisseur;
  Statut? statut;

  Transaction({
    this.id,
    required this.montant,
    this.transactionType,
    this.methodeDePayement,
    this.date,
    this.participation,
    this.wallet,
    this.compteFournisseur,
    this.statut,
  });

  // --- fromJson ---
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      montant: (json['montant'] ?? 0).toDouble(),
      transactionType: json['transactionType'] != null
          ? TransactionType.values.firstWhere(
              (e) => e.name == json['transactionType'].toString().toUpperCase(),
              orElse: () => TransactionType.RESERVATION,
            )
          : null,
      methodeDePayement: json['methodeDePayement'] != null
          ? MethodeDePayement.values.firstWhere(
              (e) =>
                  e.name == json['methodeDePayement'].toString().toUpperCase(),
              orElse: () => MethodeDePayement.ORANGE_MONEY,
            )
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      participation: json['participation'] != null
          ? Participation.fromJson(json['participation'])
          : null,
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      compteFournisseur: json['compteFournisseur'] != null
          ? CompteFournisseur.fromJson(json['compteFournisseur'])
          : null,
      statut: json['statut'] != null
          ? Statut.values.firstWhere(
              (e) => e.name == json['statut'].toString().toUpperCase(),
              orElse: () => Statut.EFFECTUER,
            )
          : null,
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'transactionType': transactionType?.name,
      'methodeDePayement': methodeDePayement?.name,
      'date': date?.toIso8601String(),
      'participation': participation?.toJson(),
      'wallet': wallet?.toJson(),
      'compteFournisseur': compteFournisseur?.toJson(),
      'statut': statut?.name,
    };
  }
}
