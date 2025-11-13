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
    final participations = widget.commande.participations ?? [];
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
              Text(
                "Membres",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                shrinkWrap: true,
                itemCount: participations.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final participe = participations[index];
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Constant.colorsgray,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    height: 20,
                    color: Constant.blueTransparant,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Constant.colorsgray,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text(
                            participe.commercant!.prenom
                                    .substring(0, 1)
                                    .toUpperCase() +
                                participe.commercant!.nom
                                    .substring(0, 1)
                                    .toUpperCase(),
                            style: TextStyle(
                              color: Constant.blue,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(participe.commercant!.prenom),
                        Text(
                          "${participe.quantite}",
                          style: TextStyle(
                            fontSize: 12,
                            backgroundColor: Constant.jauneTransparant,
                            color: Constant.jaune,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
