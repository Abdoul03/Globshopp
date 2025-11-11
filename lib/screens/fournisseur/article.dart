import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/custom/custumSearchBar.dart';
import 'package:globshopp/screens/fournisseur/custom/listeProduit.dart';
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
  void initState() {
    getSupplierProduct();
    super.initState();
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
                Column(
                  children: [
                    isLoading
                        ? CircularProgressIndicator(color: Constant.blue)
                        : ListView.separated(
                            itemCount: _produits.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final produit = _produits[index];
                              return ListeProduit(produit: produit);
                            },
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
