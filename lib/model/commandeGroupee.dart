import 'dart:ffi';

import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/model/enum/orderStatus.dart';
import 'package:globshopp/model/participation.dart';
import 'package:globshopp/model/produit.dart';
//import 'package:globshopp/screens/commandes_page.dart';

class CommandeGroupee {
  final int? id;
  double montant;
  OrderStatus? status;
  int quantiteRequis;
  int? quaniteActuelle;
  DateTime deadline;
  DateTime? dateDebut;
  Commercant? commercant;
  Produit? produit;
  List<Participation>? participations;

  CommandeGroupee({
    this.id,
    required this.montant,
    this.status,
    required this.quantiteRequis,
    this.quaniteActuelle,
    required this.deadline,
    this.dateDebut,
    this.commercant,
    this.produit,
    this.participations,
  });

  // --- fromJson ---
  factory CommandeGroupee.fromJson(Map<String, dynamic> json) {
    return CommandeGroupee(
      id: json['id'],
      montant: (json['montant'] ?? 0).toDouble(),
      status: json['status'] != null
          ? OrderStatus.values.firstWhere(
              (e) => e.name == json['status'].toString().toUpperCase(),
              orElse: () => OrderStatus.ENCOURS,
            )
          : null,
      quantiteRequis: json['quantiteRequis'] ?? 0,
      quaniteActuelle: json['quaniteActuelle'],
      deadline: DateTime.parse(json['deadline']),
      dateDebut: json['dateDebut'] != null
          ? DateTime.parse(json['dateDebut'])
          : null,
      commercant: json['commercant'] != null
          ? Commercant.fromJson(json['commercant'])
          : null,
      produit: json['produit'] != null
          ? Produit.fromJson(json['produit'])
          : null,
      participations: (json['participations'] as List?)
          ?.map((p) => Participation.fromJson(p))
          .toList(),
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'status': status?.name,
      'quantiteRequis': quantiteRequis,
      'quaniteActuelle': quaniteActuelle,
      'deadline': deadline.toIso8601String(),
      'dateDebut': dateDebut?.toIso8601String(),
      'commercant': commercant?.toJson(),
      'produit': produit?.toJson(),
      'participations': participations?.map((p) => p.toJson()).toList(),
    };
  }
}
