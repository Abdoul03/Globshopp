// lib/screens/tabs/fournisseurs_tab.dart
import 'package:flutter/material.dart';

class FournisseursTab extends StatefulWidget {
  const FournisseursTab({super.key});
  @override
  State<FournisseursTab> createState() => _FournisseursTabState();
}

class _FournisseursTabState extends State<FournisseursTab>
    with AutomaticKeepAliveClientMixin {
  static const _blue = Color(0xFF2F80ED);
  // couleurs locales supprimées (utiliser Constant si besoin)

  final _searchCtrl = TextEditingController();
  String _q = '';

  final List<Supplier> _items = List.generate(
    8,
        (_) => const Supplier(
      name: 'Aminata Traoré',
      subtitle: 'Fournisseur d’ustensiles de cuisine',
      cityCountry: 'Bamako / Mali',
      imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=300',
      verified: true,
    ),
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final top = MediaQuery.of(context).padding.top;

    final filtered = _items.where((s) {
      if (_q.isEmpty) return true;
      final q = _q.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.subtitle.toLowerCase().contains(q) ||
          s.cityCountry.toLowerCase().contains(q);
    }).toList();

    return CustomScrollView(
      slivers: [
        // Header bleu + recherche
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
            color: _blue,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _q = v.trim()),
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
                      horizontal: 14, vertical: 14),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        // Liste filtrée
        SliverList.separated(
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SupplierCard(supplier: filtered[i]),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

/* =================== Modèle & Card =================== */

class Supplier {
  final String name;
  final String subtitle;
  final String cityCountry;
  final String imageUrl;
  final bool verified;

  const Supplier({
    required this.name,
    required this.subtitle,
    required this.cityCountry,
    required this.imageUrl,
    this.verified = false,
  });
}

class SupplierCard extends StatelessWidget {
  const SupplierCard({super.key, required this.supplier});
  final Supplier supplier;

  static const _text = Color(0xFF0B0B0B);
  static const _sub  = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  @override
  Widget build(BuildContext context) {
    final isVerified = supplier.verified;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              supplier.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: const Color(0xFFF0F1F5),
                child: const Icon(Icons.image_outlined),
              ),
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
                    color: _text, fontSize: 18, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                // Sous-titre
                Text(
                  supplier.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _sub, fontSize: 13.5, height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),

                // Ligne d’infos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // État vérification
                    Row(
                      children: [
                        Icon(
                          isVerified ? Icons.verified_rounded : Icons.verified_outlined,
                          size: 16,
                          color: isVerified ? const Color(0xFF2F80ED) : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isVerified ? 'Vérifié' : 'Non vérifié',
                          style: TextStyle(
                            color: isVerified ? const Color(0xFF2F80ED) : Colors.grey,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // Ville / Pays
                    Text(
                      supplier.cityCountry,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _sub, fontSize: 13.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
