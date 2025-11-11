import 'package:flutter/material.dart';
import 'package:globshopp/model/produit.dart';

class DetailProduit extends StatefulWidget {
  final Produit produit;
  const DetailProduit({super.key, required this.produit});

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(widget.produit.nom));
  }
}
