import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/model/participation.dart';
import 'package:globshopp/model/pays.dart';
import 'package:globshopp/model/enum/role.dart';
import 'package:globshopp/model/utilisateur.dart';

class Commercant extends Utilisateur {
  List<Participation> participation;
  List<CommandeGroupee> commandeGroupees;

  Commercant({
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
    List<Participation>? participation,
    List<CommandeGroupee>? commandeGroupees,
  }) : participation = participation ?? [],
       commandeGroupees = commandeGroupees ?? [];

  factory Commercant.fromJson(Map<String, dynamic> json) {
    return Commercant(
      id: json['id'] != null ? (json['id'] as int) : null,
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      username: json['username'] ?? "",
      telephone: json['telephone'] ?? "",
      email: json['email'] ?? "",
      actif: json['actif'] ?? false,
      photoUrl: json['photoUrl'] ?? "",
      motDePasse: "",
      role: json['role'] != null ? Role.values.byName(json['role']) : null,
      pays: json['pays'] != null ? Pays.fromJson(json['pays']) : null,
      participation: json['participation'] != null
          ? List<Participation>.from(
              json['participation'].map((x) => Participation.fromJson(x)),
            )
          : [],
      commandeGroupees: json['commandeGroupees'] != null
          ? List<CommandeGroupee>.from(
              json['commandeGroupees'].map((x) => CommandeGroupee.fromJson(x)),
            )
          : [],
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
      'participation': participation.map((e) => e.toJson()).toList(),
      'commandeGroupees': commandeGroupees.map((e) => e.toJson()).toList(),
    };
  }
}
