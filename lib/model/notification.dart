class Notification {
  int id;
  String titre;
  String message;

  Notification({required this.id, required this.titre, required this.message});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      titre: json['titre'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "titre": titre, "message": message};
  }
}
