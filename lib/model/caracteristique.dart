import 'package:globshopp/model/produit.dart';

class Caracteristique {
  final int? id;
  String nom;
  String valeur;
  Produit? produit; // Relation ManyToOne vers Produit

  Caracteristique({
    this.id,
    required this.nom,
    required this.valeur,
    this.produit,
  });

  // --- fromJson ---
  factory Caracteristique.fromJson(Map<String, dynamic> json) {
    return Caracteristique(
      id: json['id'],
      nom: json['nom'] ?? '',
      valeur: json['valeur'] ?? '',
      produit: json['produit'] != null
          ? Produit.fromJson(json['produit'])
          : null,
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'valeur': valeur,
      'produit': produit?.toJson(),
    };
  }
}
