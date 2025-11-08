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
    final urls = widget.commande.produit!.mediaUrls;
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

              Row(),
            ],
          ),
        ),
      ),
    );
  }
}
