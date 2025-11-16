import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commandeGroupee.dart';
import 'package:intl/intl.dart';

class DetailCommande extends StatefulWidget {
  final CommandeGroupee commande;
  const DetailCommande({super.key, required this.commande});

  @override
  State<DetailCommande> createState() => _DetailCommandeState();
}

class _DetailCommandeState extends State<DetailCommande> {
  @override
  Widget build(BuildContext context) {
    final urls = widget.commande.produit!.mediaUrls;
    final participations = widget.commande.participation ?? [];
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      // appBar: AppBar(
      //   backgroundColor: Constant.colorsWhite,
      //   surfaceTintColor: Colors.transparent,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              SizedBox(height: 6),

              AspectRatio(
                aspectRatio: 3 / 3.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: const Color(0xFFF7F7F9),
                    child: urls.isNotEmpty
                        ? PageView.builder(
                            itemCount: urls.length,
                            itemBuilder: (_, index) {
                              final imageUrl = urls[index];
                              return Hero(
                                tag: imageUrl,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.image_outlined, size: 48),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(Icons.image_outlined, size: 48),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.commande.produit!.nom,
                    style: TextStyle(fontSize: 17),
                  ),

                  Text(
                    "${widget.commande.quantiteRequis}",
                    style: TextStyle(
                      fontSize: 23,
                      backgroundColor: Constant.jauneTransparant,
                      color: Constant.jaune,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Text(
                "Quantite Commandée : ${widget.commande.quaniteActuelle} ${widget.commande.produit!.unite.name}",
                style: TextStyle(fontSize: 17, color: Constant.blue),
              ),

              SizedBox(height: 12),

              Container(
                height: 70,
                color: Colors.grey,
                child: Row(
                  children: [
                    Container(width: 12, color: Constant.blue),
                    SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.up,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deadline",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 20),
                            Text(
                              DateFormat(
                                "dd MMM yyyy",
                              ).format(widget.commande.deadline),
                              style: TextStyle(
                                color: Constant.colorsBlack,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 130),
                        Column(
                          children: [
                            Text(
                              "Somme Totale",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 20),
                            Text("${widget.commande.montant} Fcfa"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                shrinkWrap: true,
                itemCount: participations.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final participe = participations[index];

                  // Conteneur Principal de l'item (Membres)
                  return Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ), // Ajout de padding pour l'intérieur
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Constant.colorsgray,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Alignement vertical au centre
                      children: [
                        // 1. Cercle d'Initiales (Photo de profil)
                        Container(
                          margin: EdgeInsets.only(
                            right: 10.0,
                          ), // Marge à droite
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape
                                .circle, // Utiliser un cercle pour la photo
                            color: Constant
                                .blueTransparant, // Ajouter la couleur ici
                            border: Border.all(
                              color: Constant.colorsgray,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          alignment: Alignment.center, // Centrer le texte
                          child: Text(
                            participe.commercantResponseDTO!.prenom
                                    .substring(0, 1)
                                    .toUpperCase() +
                                participe.commercantResponseDTO!.nom
                                    .substring(0, 1)
                                    .toUpperCase(),
                            style: TextStyle(
                              color: Constant.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 2. Section Nom/Adresse et Quantité (Prend le reste de l'espace)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Espacement maximal
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Colonne 2A: Nom et Adresse
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Nom Complet
                                  Text(
                                    "${participe.commercantResponseDTO!.prenom} ${participe.commercantResponseDTO!.nom}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  // Adresse (Simulée, remplacez par le vrai champ)
                                  Text(
                                    "${participe.commercantResponseDTO!.role!.name}",
                                    style: TextStyle(
                                      color: Constant.colorsgray,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              // Colonne 2B: Quantité
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Constant.jauneTransparant,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${participe.quantite}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Constant.jaune,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text("Valider"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
