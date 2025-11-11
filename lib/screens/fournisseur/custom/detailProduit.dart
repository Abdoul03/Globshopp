import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
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
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        backgroundColor: Constant.colorsWhite,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: SafeArea(child: Text(widget.produit.nom)),
      ),
    );
  }
}
