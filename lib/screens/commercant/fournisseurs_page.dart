// lib/screens/fournisseurs_page.dart
import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import '../supplier_detail_page.dart';

class FournisseursPage extends StatefulWidget {
  const FournisseursPage({super.key});

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  final _searchCtrl = TextEditingController();

  // ----- Données démo -----
  final List<Supplier> _items = const [
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
    Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      image: 'assets/image/ustensils.png',
      isAsset: true,
      verified: true,
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ------------ CONTENU ------------
      body: CustomScrollView(
        slivers: [
          // Bandeau bleu fixe avec champ de recherche
          SliverAppBar(
            pinned: true,
            backgroundColor: Constant.blue,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 0, // on n'affiche que la partie "bottom"
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(88),
              child: Container(
                color: Constant.blue,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 52),
                  child: _SearchField(controller: _searchCtrl),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // Liste des fournisseurs
          SliverList.separated(
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SupplierCard(
                supplier: _items[i],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SupplierDetailPage(supplier: _items[i]),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

/* =================== Modèle =================== */

class Supplier {
  final String name;
  final String subtitle;
  final String cityCountry;
  final String image; // asset ou URL
  final bool isAsset;
  final bool verified;

  const Supplier({
    required this.name,
    required this.subtitle,
    required this.cityCountry,
    required this.image,
    this.isAsset = false,
    this.verified = false,
  });
}

/* =================== Widgets =================== */

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Rechercher',
          prefixIcon: const Icon(Icons.search_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class SupplierCard extends StatelessWidget {
  const SupplierCard({super.key, required this.supplier, this.onTap});
  final Supplier supplier;
  final VoidCallback? onTap;

  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  @override
  Widget build(BuildContext context) {
    final imageWidget = supplier.isAsset
        ? Image.asset(
            supplier.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackImage(),
          )
        : Image.network(
            supplier.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackImage(),
          );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap, // ✅ clique → navigation
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: _cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image (avec Hero pour une transition fluide)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: 'supplier:${supplier.image}_${supplier.name}',
                  child: imageWidget,
                ),
              ),
              const SizedBox(width: 12),

              // Textes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom
                    Text(
                      supplier.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Sous-titre
                    Text(
                      supplier.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _sub,
                        fontSize: 13.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Ligne: "Vérifier" à gauche — Ville/Pays à droite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          supplier.verified ? 'Vérifier' : 'Non vérifié',
                          style: TextStyle(
                            color: supplier.verified
                                ? const Color(0xFF2F80ED)
                                : Colors.grey,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          supplier.cityCountry,
                          style: const TextStyle(color: _sub, fontSize: 13.5),
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
    );
  }

  Widget _fallbackImage() => Container(
    width: 64,
    height: 64,
    color: const Color(0xFFF0F1F5),
    child: const Icon(Icons.image_outlined),
  );
}

/// Icône image (mêmes assets que tes autres écrans)
