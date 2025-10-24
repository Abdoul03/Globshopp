import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/product_detail_page.dart';
import 'package:globshopp/services/produitService.dart';

class Productcard extends StatefulWidget {
  final Produit produit;
  const Productcard({super.key, required this.produit});

  @override
  State<Productcard> createState() => _ProductcardState();
}

class _ProductcardState extends State<Productcard> {
  @override
  Widget build(BuildContext context) {
    final urls = widget.produit.mediaUrls;
    final imageUrl = urls.isNotEmpty ? urls.first : null;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        //Vers le détail produit
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(produit: widget.produit),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Constant.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: const Color(0xFFF7F7F9),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.image_outlined, size: 36),
                                  ),
                                )
                              : const Center(
                                  child: Icon(Icons.image_outlined, size: 36),
                                ),
                        ),
                      ),
                    ),
                    // if (widget.produit.badge != null)
                    //   Positioned(
                    //     top: 6,
                    //     right: 6,
                    //     child: Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 6,
                    //         vertical: 2,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: const Color(0xFF3CC36C),
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       child: Text(
                    //         widget.produit.badge!,
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.w700,
                    //           height: 1.0,
                    //           letterSpacing: 0.1,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.produit.nom,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Constant.colorsBlack,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${widget.produit.prix} FCFA",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${widget.produit.moq} ${widget.produit.unite.toString()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Constant.grisClaire,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.produit.fournisseur!.nom,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Constant.grisClaire,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
