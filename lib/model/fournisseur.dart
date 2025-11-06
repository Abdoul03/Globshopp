import 'package:globshopp/model/compteFournisseur.dart';
import 'package:globshopp/model/pays.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/model/enum/role.dart';
import 'package:globshopp/model/utilisateur.dart';

class Fournisseur extends Utilisateur {
  List<Produit>? produit;
  CompteFournisseur? comptefournisseur;
  Fournisseur({
    super.id,
    required super.nom,
    required super.prenom,
    required super.username,
    required super.telephone,
    required super.email,
    super.actif,
    super.photoUrl,
    required super.motDePasse,
    super.role,
    super.pays,
    List<Produit>? produit,
    this.comptefournisseur,
  }) : produit = produit ?? [];

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      id: json['id'] != null ? (json['id'] as int) : null,
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      username: json['username'] ?? "",
      telephone: json['telephone'] ?? "",
      email: json['email'] ?? "",
      actif: json['actif'] ?? false,
      photoUrl: json['photoUrl'],
      motDePasse: "",
      role: json['role'] != null ? Role.values.byName(json['role']) : null,
      pays: json['pays'] != null ? Pays.fromJson(json['pays']) : null,
      produit: json['produit'] != null
          ? List<Produit>.from(json['produit'].map((x) => Produit.fromJson(x)))
          : [],
      comptefournisseur: json['compteFournisseur'] != null
          ? CompteFournisseur.fromJson(json['compteFournisseur'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'username': username,
      'telephone': telephone,
      'email': email,
      'actif': actif,
      'photoUrl': photoUrl,
      'motDePasse': motDePasse,
      'role': role?.name,
      'pays': pays?.toJson(),
      'produit': produit?.map((e) => e.toJson()).toList(),
      'compteFournisseur': comptefournisseur?.toJson(),
    };
  }
}
