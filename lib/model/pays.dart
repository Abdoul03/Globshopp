class Pays {
  final int id;
  final String nom;

  Pays({required this.id, required this.nom});

  factory Pays.fromJson(Map<String, dynamic> json) {
    return Pays(id: json['id'], nom: json['nom']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nom': nom};
  }
}
