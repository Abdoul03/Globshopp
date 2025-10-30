import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/commercant/supplier_detail_page.dart';
import '../group_order_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Produit produit;
  const ProductDetailPage({super.key, required this.produit});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final storage = FlutterSecureStorage();

  String? extractIdFromToken(String accessToken) {
    try {
      // Le token a la forme header.payload.signature
      final parts = accessToken.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      // Base64Url decoding
      var normalized = base64Url.normalize(payload);
      final payloadMap = jsonDecode(utf8.decode(base64Url.decode(normalized)));

      if (payloadMap is! Map<String, dynamic>) return null;
      return payloadMap['sub'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.produit.mediaUrls;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
              // if (produit.mediaUrls.isNotEmpty)
              //   SizedBox(
              //     height: 200,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: produit.mediaUrls.length,
              //       itemBuilder: (context, index) {
              //         final url = produit.mediaUrls[index];
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //           child: Image.network(url, fit: BoxFit.cover),
              //         );
              //       },
              //     ),
              //   )
              // else
              //   const Center(child: Icon(Icons.image_outlined, size: 36)),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Prix
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.produit.prix}",
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Constant.colorsBlack,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Prix unitaire',
                          style: TextStyle(
                            fontSize: 11,
                            color: Constant.grisClaire,
                          ),
                        ),
                      ],
                    ),

                    // MOQ
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'MOQ:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Constant.colorsgray,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${widget.produit.moq}",
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                            color: Constant.jaune,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ─────────── Titre produit ───────────
              Text(
                widget.produit.nom,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Constant.colorsBlack,
                ),
              ),
              const SizedBox(height: 6),

              // ─────────── Description ───────────
              Text(
                widget.produit.description,
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
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupplierDetailPage(
                              supplier: widget.produit.fournisseur!,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.produit.fournisseur!.prenom} ${widget.produit.fournisseur!.nom}",
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
                    if (widget.produit.commandeGroupees != null &&
                        widget.produit.commandeGroupees!.isNotEmpty) {
                      // Rejoindre la commande existante
                      // TODO : Ajouter la logique pour rejoindre
                    } else {
                      // Créer une nouvelle commande
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GroupOrderPage(produit: widget.produit),
                        ),
                      );
                    }
                  },
                  child: Text(
                    widget.produit.commandeGroupees != null &&
                            widget.produit.commandeGroupees!.isNotEmpty
                        ? 'Rejoindre la commande'
                        : 'Créer une commande',
                    style: const TextStyle(
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
