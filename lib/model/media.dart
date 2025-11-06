import 'package:globshopp/model/produit.dart';

class Media {
  final int? id;
  String fileName;
  String fileType;
  String filePath;
  Produit? produit; // Relation ManyToOne vers Produit

  Media({
    this.id,
    required this.fileName,
    required this.fileType,
    required this.filePath,
    this.produit,
  });

  // --- fromJson ---
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      fileName: json['fileName'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'] ?? '',
      produit: json['produit'] != null
          ? Produit.fromJson(json['produit'])
          : null,
    );
  }

  // --- toJson ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'filePath': filePath,
      'produit': produit?.toJson(), // sérialisation récursive si nécessaire
    };
  }
}
