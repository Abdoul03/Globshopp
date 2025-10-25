import 'package:flutter/material.dart';
import 'package:globshopp/model/produit.dart';

class Categorie {
  final int? id;
  String nom;
  final IconData? icone;
  List<Produit> produit;

  Categorie({this.id, required this.nom, this.icone, List<Produit>? produit})
    : produit = produit ?? [];

  // --- fromJson ---
  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      nom: json['nom'] ?? '',
      produit:
          (json['produit'] as List?)
              ?.map((p) => Produit.fromJson(p))
              .toList() ??
          [],
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'produit': produit.map((p) => p.toJson()).toList(),
    };
  }
}
