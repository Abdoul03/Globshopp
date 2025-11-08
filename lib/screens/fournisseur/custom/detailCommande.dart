import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commandeGroupee.dart';

class DetailCommande extends StatefulWidget {
  final CommandeGroupee commande;
  const DetailCommande({super.key, required this.commande});

  @override
  State<DetailCommande> createState() => _DetailCommandeState();
}

class _DetailCommandeState extends State<DetailCommande> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        backgroundColor: Constant.colorsWhite,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(children: []),
    );
  }
}
