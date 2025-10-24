import 'package:globshopp/model/enum/statut.dart';
import 'package:globshopp/model/transaction.dart';

class Wallet {
  final int? id;
  double montant;
  DateTime? miseAjour;
  Statut? statut;
  List<Transaction>? transactions;
  String numero;

  Wallet({
    this.id,
    required this.montant,
    this.miseAjour,
    this.statut,
    this.transactions,
    required this.numero,
  });

  // --- fromJson ---
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      montant: (json['montant'] ?? 0).toDouble(),
      miseAjour: json['miseAjour'] != null
          ? DateTime.parse(json['miseAjour'])
          : null,
      statut: json['statut'] != null
          ? Statut.values.firstWhere(
              (e) => e.name == json['statut'].toString().toUpperCase(),
              orElse: () => Statut.EFFECTUER,
            )
          : null,
      transactions: (json['transactions'] as List?)
          ?.map((t) => Transaction.fromJson(t))
          .toList(),
      numero: json['numero'] ?? '',
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'miseAjour': miseAjour?.toIso8601String(),
      'statut': statut?.name,
      'transactions': transactions?.map((t) => t.toJson()).toList(),
      'numero': numero,
    };
  }
}
