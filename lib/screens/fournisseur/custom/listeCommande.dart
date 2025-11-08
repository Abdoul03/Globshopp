import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/screens/commercant/commandes_page.dart';
import 'package:globshopp/screens/fournisseur/custom/detailCommande.dart';
import 'package:intl/intl.dart';

class Listecommande extends StatefulWidget {
  final List<CommandeGroupee> commandeGroupee;
  const Listecommande({super.key, required this.commandeGroupee});

  @override
  State<Listecommande> createState() => _ListecommandeState();
}

class _ListecommandeState extends State<Listecommande> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.commandeGroupee.length,
      itemBuilder: (context, index) {
        final commande = widget.commandeGroupee[index];
        return GestureDetector(
          onTap: () {
            // action quand on clique sur une commande
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailCommande(commande: commande),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Constant.colorsgray, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 95,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Constant.colorsgray, width: 1),
                  ),
                  child: Image.network(
                    commande.produit!.mediaUrls.first,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        commande.produit!.nom ?? "Nom du produit",
                        style: TextStyle(
                          color: Constant.colorsBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Quantité requis : ${commande.quantiteRequis} ${commande.produit!.unite.name} ",
                        style: TextStyle(color: Constant.jaune, fontSize: 12),
                      ),
                      Text(
                        "Quantité commandée : ${commande.quaniteActuelle} ${commande.produit!.unite.name}",
                        style: TextStyle(color: Constant.blue),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Deadline: ",
                                style: TextStyle(
                                  color: Constant.colorsBlack,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat(
                                  "dd MMM yyyy",
                                ).format(commande.deadline),
                                style: TextStyle(
                                  color: Constant.colorsBlack,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Prix : ${commande.produit!.prix ?? 'N/A'} fcfa",
                                style: TextStyle(
                                  color: Constant.colorsBlack,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "${commande.status!.name}",
                                style: TextStyle(
                                  color: Constant.colorsBlack,
                                  fontSize: 10,
                                  //backgroundColor: ,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
