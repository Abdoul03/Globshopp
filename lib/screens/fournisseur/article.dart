import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/fournisseur/custom/custumSearchBar.dart';
import 'package:globshopp/services/produitService.dart';
import 'package:remixicon/remixicon.dart';

class Article extends StatefulWidget {
  const Article({super.key});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  final _searchController = TextEditingController();

  List<Produit> _produits = [];
  List<Produit> _searchResults = [];
  bool isLoading = false;

  final Produitservice _produitservice = Produitservice();

  Future<void> getSupplierProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      final produits = await _produitservice.getFournisseurProduits();
      setState(() {
        _produits = produits;
        _searchResults = produits;
        isLoading = false;
      });
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits : $e');
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        setState(() {
          _searchResults = _produits;
        });
        return;
      }

      setState(() {
        _searchResults = _produits.where((produit) {
          final titreMatch = produit.nom.toLowerCase().contains(
            text.toLowerCase(),
          );
          final descMatch = produit.description.toLowerCase().contains(
            text.toLowerCase(),
          );
          return titreMatch || descMatch;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Constant.colorsWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.all(20),
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make it a circle
                        border: Border.all(
                          color: Constant.colorsgray,
                          width: 2.0,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(RemixIcons.notification_2_line),
                        color: Constant.colorsBlack,
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.all(20),
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make it a circle
                        border: Border.all(
                          color: Constant.colorsgray,
                          width: 2.0,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(RemixIcons.history_line),
                        color: Constant.colorsBlack,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 33),
                //Bar de recherche
                Custumsearchbar(
                  hintText: "Rechercher",
                  onchange: _onSearchTextChanged,
                  controller: _searchController,
                ),
                const SizedBox(height: 20),

                //Contenaire de produits
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 400,
                    height: 115,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Constant.colorsgray,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        //Image
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          width: 95,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Constant.colorsgray,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text("Image"),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "T-shirts coton “Everyday Fit” ",
                                style: TextStyle(
                                  color: Constant.colorsBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Prix : 1000 fcfa",
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Constant.colorsgray),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "MOQ : 144 pieces",
                                    style: TextStyle(color: Constant.jaune),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Stock : 20000",
                                    style: TextStyle(
                                      color: Constant.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
