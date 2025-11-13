import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/caracteristique.dart';
import 'package:globshopp/model/categorie.dart';
import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:globshopp/model/media.dart';
import 'package:globshopp/model/enum/uniteProduit.dart';

class Produit {
  final int? id;
  String nom;
  String description;
  double prix;
  int moq;
  int stock;
  Uniteproduit unite;
  List<Media> media;
  List<Caracteristique> caracteristiques;
  Fournisseur? fournisseur;
  Categorie? categorie;
  int categorieId;
  List<CommandeGroupee>? commandeGroupees;

  Produit({
    this.id,
    required this.nom,
    required this.description,
    required this.prix,
    required this.moq,
    required this.stock,
    required this.unite,
    this.media = const [],
    required this.caracteristiques,
    this.fournisseur,
    this.categorie,
    required this.categorieId,
    this.commandeGroupees,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      prix: json['prix'] != null ? (json['prix'] as num).toDouble() : 0.0,
      moq: json['moq'] != null ? json["moq"] as int : 0,
      stock: json['stock'] != null ? json["stock"] as int : 0,
      unite: Uniteproduit.values.firstWhere(
        (e) => e.name == (json['unite'] ?? '').toUpperCase(),
        orElse: () => Uniteproduit.PIECES, // valeur par défaut
      ),
      media: (json['media'] as List).map((m) => Media.fromJson(m)).toList(),
      caracteristiques: (json['caracteristiques'] as List)
          .map((c) => Caracteristique.fromJson(c))
          .toList(),
      fournisseur: json['fournisseur'] != null
          ? Fournisseur.fromJson(json['fournisseur'])
          : null,
      categorie: json['categorie'] != null
          ? Categorie.fromJson(json['categorie'])
          : null,
      categorieId:
          (json['categorieId'] != null ? json['categorieId'] as num : 0)
              .toInt(),
      commandeGroupees: (json['commandeGroupees'] as List?)
          ?.map((cmd) => CommandeGroupee.fromJson(cmd))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prix': prix,
      'moq': moq,
      'stock': stock,
      'unite': unite.name,
      'media': media?.map((m) => m.toJson()).toList(),
      'caracteristiques': caracteristiques.map((c) => c.toJson()).toList(),
      'fournisseur': fournisseur?.toJson(),
      'categorie': categorie?.toJson(),
      'categorieId': categorieId,
      'commandeGroupees': commandeGroupees?.map((cmd) => cmd.toJson()).toList(),
    };
  }

  /// Retourne la liste des URLs complètes pour Flutter
  List<String> get mediaUrls {
    if (media.isEmpty) return [];
    return media!.map((m) => "${Constant.remoteUrl}${m.webPath}").toList();
  }

  String? get firstImageUrl => mediaUrls.isNotEmpty ? mediaUrls.first : null;
}
