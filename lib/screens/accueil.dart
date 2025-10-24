// lib/screens/accueil.dart
import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/categoryChip.dart';
import 'package:globshopp/screens/productCard.dart';
import 'package:globshopp/services/produitService.dart';
import 'package:globshopp/widgets/animated_bottom_nav.dart';
import 'notifications_page.dart';
// import 'package:globshopp/_base/constant.dart'; // inutilisé ici

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategory = 0;

  final _categories = const [
    ('Tous', Icons.grid_view_rounded),
    ('Accessoires', Icons.headphones_rounded),
    ('Electronique', Icons.devices_other_rounded),
    ('Habits', Icons.checkroom_rounded),
    ('Electro', Icons.kitchen_rounded),
  ];

  final Produitservice _produitservice = Produitservice();
  List<Produit> _produits = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    chargerProduits();
  }

  Future<void> chargerProduits() async {
    try {
      final produit = await _produitservice.getAllProduits();
      setState(() {
        _produits = produit;
        _loading = false;
      });
    } catch (e) {
      print("Erreur de chargement : $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: Constant.blue));
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          // Barre d’en-tête avec recherche
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            expandedHeight: 140,
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFF0F3FF),
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: 22,
                  height: 22,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.shopping_cart_outlined, size: 18),
                ),
              ),
            ),
            actions: [
              // Quand on appuie, on ouvre NotificationsPage
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Constant.grisClaire),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Constant.border),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Constant.blue),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- Titre Catégories ---
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, top > 0 ? 16 : 16, 16, 10),
              child: const Text(
                'Catégories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Constant.colorsBlack,
                ),
              ),
            ),
          ),

          // --- Liste des catégories ---
          SliverToBoxAdapter(
            child: SizedBox(
              height: 112,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  final (label, icon) = _categories[i];
                  return CategoryChip(
                    label: label,
                    icon: icon,
                    selected: i == _selectedCategory,
                    onTap: () => setState(() => _selectedCategory = i),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: _categories.length,
              ),
            ),
          ),

          // --- Grille de produits ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Productcard(produit: _produits[index]),
                childCount: _produits.length,
              ),
            ),
          ),
        ],
      ),

      // --- Barre de navigation du bas (réutilisable) ---
      bottomNavigationBar: AnimatedBottomNavBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          if (i == 0) return;
          if (i == 1) Navigator.pushReplacementNamed(context, '/fournisseurs');
          if (i == 2) Navigator.pushReplacementNamed(context, '/commandes');
          if (i == 3) Navigator.pushReplacementNamed(context, '/annuaire');
          if (i == 4) Navigator.pushReplacementNamed(context, '/profil');
        },
      ),
    );
  }
}
