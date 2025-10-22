class Participation {
  final int? id;
  Participation({this.id});

  factory Participation.fromJson(Map<String, dynamic> json) {
    return Participation(id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id};
}
