// lib/screens/fournisseurs_page.dart
import 'package:flutter/material.dart';

class FournisseursPage extends StatefulWidget {
  const FournisseursPage({super.key});

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  // Couleurs
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  final _searchCtrl = TextEditingController();
  int _currentIndex = 1; // Fournisseurs actif

  final _items = List.generate(
    8,
        (_) => const Supplier(
      name: 'Aminata traoré',
      subtitle: 'Fournisseur d’ustensils de cuisine',
      cityCountry: 'Bamako/Mali',
      imageUrl:
      'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=300',
      verified: true,
    ),
  );

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --------- En-tête bleu + Recherche ---------
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
              color: _blue,
              child: _SearchField(controller: _searchCtrl),
            ),
          ),

          // Espacement sous l’entête
          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // --------- Liste des fournisseurs ---------
          SliverList.separated(
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SupplierCard(supplier: _items[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),

      // --------- Navigation Bar (même style que tes autres pages) ---------
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          height: 84,
          indicatorColor: Color(0x142F80ED),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            if (i == 0) {
              // Accueil
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/accueil',
                    (r) => false,
              );
              return;
            }
            if (i == 2) {
              // Commandes
              Navigator.pushNamed(context, '/commandes');
              return;
            }
            // Visuel uniquement pour Annuaire/Profil (à brancher plus tard)
            setState(() => _currentIndex = i);
          },
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          destinations: const [
            NavigationDestination(
              icon: _NavIcon('assets/icons/home.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/home_active.png', size: 28),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/store.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/store_active.png', size: 28),
              label: 'Fournisseurs',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/orders.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/orders_active.png', size: 28),
              label: 'Commandes',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/contacts.png', size: 28),
              selectedIcon:
              _NavIcon('assets/icons/contacts_active.png', size: 28),
              label: 'Annuaire',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/profile.png', size: 28),
              selectedIcon:
              _NavIcon('assets/icons/profile_active.png', size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
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
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

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
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  @override
  Widget build(BuildContext context) {
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
                    InkWell(
                      onTap: () {},
                      child: Text(
                        supplier.verified ? 'Vérifier' : 'Non vérifié',
                        style: TextStyle(
                          color: supplier.verified
                              ? const Color(0xFF2F80ED)
                              : Colors.grey,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      supplier.cityCountry,
                      style: const TextStyle(
                        color: _sub,
                        fontSize: 13.5,
                      ),
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

/// Icône image (mêmes assets que tes autres écrans)
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 26, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}
