// lib/screens/annuaire_page.dart
import 'package:flutter/material.dart';

class AnnuairePage extends StatefulWidget {
  const AnnuairePage({super.key});

  @override
  State<AnnuairePage> createState() => _AnnuairePageState();
}

class _AnnuairePageState extends State<AnnuairePage> {
  // Couleurs
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _sub  = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  final _searchCtrl = TextEditingController();
  int _currentIndex = 3; // Annuaire actif

  final _companies = <Company>[
    Company(
      name: 'Global Logistics inc',
      description: 'Spécialisé dans le fret aérien et maritime international.',
      phone: '+223 85 47 47 57',
      logo: 'assets/icons/global_logistics.png',
    ),
    Company(
      name: 'Swift Cargo Solutions',
      description:
      'Votre partenaire fiable pour un transport de marchandises sans faille.',
      phone: '+223 85 47 47 57',
      logo: 'assets/icons/swift_cargo.png',
    ),
    Company(
      name: 'Sekou Keïta',
      description: 'Un transport de fret efficace et rentable',
      phone: '+223 85 47 47 57',
      logo: 'assets/icons/trans_express.png',
    ),
  ];

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
          // --------- En-tête bleu + Recherche (même style que Fournisseurs) ---------
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
              color: _blue,
              child: _SearchField(controller: _searchCtrl),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // --------- Liste des entreprises ---------
          SliverList.separated(
            itemCount: _companies.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CompanyCard(company: _companies[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),

      // --------- Navigation Bar (exactement la même que FournisseursPage) ---------
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
              Navigator.pushNamedAndRemoveUntil(context, '/accueil', (r) => false);
              return;
            }
            if (i == 1) {
              // Fournisseurs
              Navigator.pushNamed(context, '/fournisseurs');
              return;
            }
            if (i == 2) {
              // Commandes
              Navigator.pushNamed(context, '/commandes');
              return;
            }
            if (i == 4) {
              // Profil
              Navigator.pushNamed(context, '/profil');
              return;
            }
            // i == 3 => Annuaire (page actuelle) : juste maj visuelle
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
              selectedIcon: _NavIcon('assets/icons/contacts_active.png', size: 28),
              label: 'Annuaire',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/profile.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/profile_active.png', size: 28),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

class Company {
  final String name;
  final String description;
  final String phone;
  final String logo;

  Company({
    required this.name,
    required this.description,
    required this.phone,
    required this.logo,
  });
}

class CompanyCard extends StatelessWidget {
  final Company company;
  const CompanyCard({super.key, required this.company});

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
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // 🖼️ Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              company.logo,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported_outlined, size: 40),
            ),
          ),
          const SizedBox(width: 12),

          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _sub,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  company.phone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _text,
                    fontWeight: FontWeight.w600,
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
