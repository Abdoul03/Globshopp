class Comptefournisseur {
  final int? id;
  Comptefournisseur({this.id});

  factory Comptefournisseur.fromJson(Map<String, dynamic> json) {
    return Comptefournisseur(id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id};
}
