// lib/screens/tabs/annuaire_tab.dart
import 'package:flutter/material.dart';

class AnnuaireTab extends StatefulWidget {
  const AnnuaireTab({super.key});

  @override
  State<AnnuaireTab> createState() => _AnnuaireTabState();
}

class _AnnuaireTabState extends State<AnnuaireTab>
    with AutomaticKeepAliveClientMixin {
  // Palette
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _sub  = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  final _searchCtrl = TextEditingController();
  String _q = '';

  final List<DirectoryEntry> _all = const [
    DirectoryEntry(
      name: 'Global Logistics inc',
      desc: 'Spécialisé dans le fret aérien et maritime international.',
      phone: '+223 85 47 47 57',
      imageUrl: 'https://i.imgur.com/Nw9x3jD.png',
    ),
    DirectoryEntry(
      name: 'Swift Cargo Solutions',
      desc: 'Votre partenaire fiable pour un transport de marchandises sans faille.',
      phone: '+223 85 47 47 57',
      imageUrl: 'https://i.imgur.com/7mxyH4p.png',
    ),
    DirectoryEntry(
      name: 'Sekou keïta',
      desc: 'Un transport de fret efficace et rentable',
      phone: '+223 85 47 47 57',
      imageUrl: 'https://i.imgur.com/Bq3nCqk.png',
    ),
  ];

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

    final entries = _all.where((e) {
      if (_q.isEmpty) return true;
      final q = _q.toLowerCase();
      return e.name.toLowerCase().contains(q)
          || e.desc.toLowerCase().contains(q)
          || e.phone.toLowerCase().contains(q);
    }).toList();

    return CustomScrollView(
      slivers: [
        // Header bleu + champ de recherche
        SliverToBoxAdapter(
          child: Container(
            color: _blue,
            padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        // Liste filtrée
        SliverList.separated(
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DirectoryCard(entry: entries[i]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

/* =================== Modèle & Card =================== */

class DirectoryEntry {
  final String name;
  final String desc;
  final String phone;
  final String imageUrl;
  const DirectoryEntry({
    required this.name,
    required this.desc,
    required this.phone,
    required this.imageUrl,
  });
}

class DirectoryCard extends StatelessWidget {
  const DirectoryCard({super.key, required this.entry});
  final DirectoryEntry entry;

  static const _text = Color(0xFF0B0B0B);
  static const _sub  = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              entry.imageUrl,
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: _sub,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.phone,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
