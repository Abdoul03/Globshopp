// lib/screens/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import '../group_order_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Produit produit;
  const ProductDetailPage({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    final urls = produit.mediaUrls;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // ✅ Scrollable
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────── AppBar (retour) ───────────
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(height: 6),

              // ─────────── Image produit ───────────
              if (produit.mediaUrls.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: produit.mediaUrls.length,
                    itemBuilder: (context, index) {
                      final url = produit.mediaUrls[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.network(url, fit: BoxFit.cover),
                      );
                    },
                  ),
                )
              else
                const Center(child: Icon(Icons.image_outlined, size: 36)),
              // AspectRatio(
              //   aspectRatio: 3 / 3.5,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8),
              //     child: Container(
              //       color: const Color(0xFFF7F7F9),
              //       child: urls.isNotEmpty
              //           ? PageView.builder(
              //               itemCount: urls.length,
              //               itemBuilder: (_, index) {
              //                 final imageUrl = urls[index];
              //                 return Hero(
              //                   tag: imageUrl,
              //                   child: Image.network(
              //                     imageUrl,
              //                     fit: BoxFit.contain,
              //                     errorBuilder: (_, __, ___) => const Center(
              //                       child: Icon(Icons.image_outlined, size: 48),
              //                     ),
              //                   ),
              //                 );
              //               },
              //             )
              //           : const Center(
              //               child: Icon(Icons.image_outlined, size: 48),
              //             ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // ─────────── Bloc prix + MOQ ───────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Constant.colorsgray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Constant.border),
                ),
                child: Row(
                  children: [
                    // Prix
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${produit.prix}",
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Constant.colorsBlack,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Prix unitaire',
                            style: TextStyle(
                              fontSize: 11,
                              color: Constant.grisClaire,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // MOQ
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'MOQ:',
                            style: TextStyle(
                              fontSize: 11,
                              color: Constant.colorsgray,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${produit.moq}",
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              color: Constant.jaune,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ─────────── Titre produit ───────────
              Text(
                produit.nom,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Constant.colorsBlack,
                ),
              ),
              const SizedBox(height: 6),

              // ─────────── Description ───────────
              Text(
                produit.description,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Constant.colorsgray,
                ),
              ),

              const SizedBox(height: 12),

              // ─────────── Carte Fournisseur ───────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Constant.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.store_mall_directory_outlined,
                        size: 17,
                        color: Constant.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produit.fournisseur!.nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Constant.colorsBlack,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Fournisseur Grossiste',
                            style: TextStyle(
                              fontSize: 11,
                              color: Constant.jaune,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ─────────── Bouton principal ───────────
              SizedBox(
                height: 44,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // ✅ Navigation vers la page de commande groupée
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupOrderPage(
                          productTitle: produit.nom,
                          // on convertit "1000 FCFA" → 1000.0
                          unitPrice: double.tryParse("${produit.prix}") ?? 0,
                          // on convertit "MOQ: 20 pcs" → 20
                          moq: int.tryParse("${produit.moq}") ?? 0,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Créer une commande',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
