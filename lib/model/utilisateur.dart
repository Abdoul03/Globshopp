import 'dart:ffi';

import 'package:globshopp/model/pays.dart';
import 'package:globshopp/model/role.dart';

abstract class Utilisateur {
  // Propriétés
  final Long? id;
  String nom;
  String prenom;
  String username;
  String telephone;
  String email;
  bool? actif;
  String? photoUrl;
  String motDePasse;
  Role? role;
  Pays? pays;

  // Constructeur principal
  Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.username,
    required this.telephone,
    required this.email,
    this.actif = false,
    this.photoUrl,
    required this.motDePasse,
    this.role,
    this.pays,
  });
}
