import 'package:flutter/material.dart';

class AccueilTab extends StatelessWidget {
  const AccueilTab({super.key});

  static const _text = Color(0xFF0B0B0B);
  static const _cardBorder = Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          expandedHeight: 140,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFF0F3FF),
              child: Image.asset(
                'assets/icons/logo.png',
                width: 22, height: 22,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.shopping_cart_outlined, size: 18),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded,
                  color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.history_rounded, color: Colors.black87),
              onPressed: () {},
            ),
            const SizedBox(width: 6),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _cardBorder),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Text('Catégories',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: _text)),
          ),
        ),
        // ... ajoute ici tes chips et ta grille produits comme avant ...
        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ],
    );
  }
}
