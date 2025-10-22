import 'dart:ffi';

class Produit {
  final Long? id;
  final String nom;

  Produit({this.id, required this.nom});

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(id: json['id'], nom: json['nom']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nom': nom};
  }
}
