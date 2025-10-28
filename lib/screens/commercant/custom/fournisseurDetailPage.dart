import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/fournisseur.dart';

class FournisseurDetailPage extends StatefulWidget {
  final Fournisseur fournisseur;
  const FournisseurDetailPage({super.key, required this.fournisseur});

  @override
  State<FournisseurDetailPage> createState() => _FournisseurDetailPageState();
}

class _FournisseurDetailPageState extends State<FournisseurDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        // title: Text("Detail Fournisseur"),
        backgroundColor: Constant.colorsWhite,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(child: SingleChildScrollView(child: Column())),
    );
  }
}
