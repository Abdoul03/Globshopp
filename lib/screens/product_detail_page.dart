// lib/screens/product_detail_page.dart
import 'package:flutter/material.dart';
import 'accueil.dart' show Product;

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  // 🎨 Palette
  static const _blue        = Color(0xFF2F80ED);
  static const _text        = Color(0xFF0B0B0B);
  static const _sub         = Color(0xFF6B6F76);
  static const _muted       = Color(0xFF9AA0A6);
  static const _chipBeige   = Color(0xFFF6EBD7);
  static const _beigeBorder = Color(0xFFE9D9BD);
  static const _tileBorder  = Color(0xFFEAEAEA);
  static const _yellow      = Color(0xFFE9AB30);

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black87, size: 20),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(height: 6),

              // ─────────── Image produit ───────────
              AspectRatio(
                aspectRatio: 3 / 3.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: const Color(0xFFF7F7F9),
                    child: Hero(
                      tag: product.image,
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_outlined,
                              size: 48, color: _muted),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ─────────── Bloc prix + MOQ ───────────
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _chipBeige,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _beigeBorder),
                ),
                child: Row(
                  children: [
                    // Prix
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.price,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Prix unitaire',
                            style:
                            TextStyle(fontSize: 11, color: _sub),
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
                              color: _muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.moq,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              color: _yellow,
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
                product.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              const SizedBox(height: 6),

              // ─────────── Description ───────────
              const Text(
                'Produit fabriqué à partir de coton de haute qualité, idéal pour un usage quotidien. Léger, confortable et durable.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: _sub,
                ),
              ),

              const SizedBox(height: 12),

              // ─────────── Carte Fournisseur ───────────
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _tileBorder),
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
                      child: const Icon(Icons.store_mall_directory_outlined,
                          size: 17, color: _blue),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Fournisseur Grossiste',
                            style: TextStyle(
                              fontSize: 11,
                              color: _yellow,
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
                    backgroundColor: _blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Action commande
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
