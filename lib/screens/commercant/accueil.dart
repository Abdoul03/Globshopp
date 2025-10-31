// lib/screens/accueil.dart
import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/categorie.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/custom/categoryChip.dart';
import 'package:globshopp/screens/commercant/custom/productCard.dart';
import 'package:globshopp/screens/commercant/custom/product_detail_page.dart';
import 'package:globshopp/services/categorieService.dart';
import 'package:globshopp/services/produitService.dart';
import 'package:remixicon/remixicon.dart';
import '../notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategory = 0;

  final Produitservice _produitservice = Produitservice();
  final CategorieService _categorieService = CategorieService();

  final TextEditingController _searchContoller = TextEditingController();

  List<Produit> _produits = [];
  List<Produit> _searchResults = [];
  List<Categorie> categories = [];

  // List<Map<String, Object?>> categories = [];
  bool _loading = true;

  @override
  void initState() {
    chargerCategorie();
    chargerProduits();
    super.initState();
  }

  Future<void> chargerCategorie() async {
    try {
      final categorie = await _categorieService.getAllCategoeri();
      setState(() {
        categories = [
          Categorie(id: 0, nom: "Tout"),
          ...categorie.map(
            (cat) => Categorie(
              id: cat.id,
              nom: cat.nom,
              icone: _getIconForCategory(cat.nom),
            ),
          ),
        ];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      throw Exception('Erreur lors de la récupération des categories : $e');
    }
  }

  IconData _getIconForCategory(String? nomCategorie) {
    if (nomCategorie == null) return Icons.grid_view_rounded;

    final nom = nomCategorie.toLowerCase().trim();

    switch (nom) {
      case 'tout':
        return RemixIcons.menu_2_line;
      case 'accessoire':
      case 'accesoire':
      case 'accessoir': // au cas où ton back envoie sans le 'e'
        return Icons.headphones_rounded;
      case 'electronique':
      case 'électronique': // pour couvrir les deux orthographes
        return Icons.devices_other_rounded;
      case 'habit':
      case 'habits':
        return Icons.checkroom_rounded;
      case 'electro':
      case 'electromenager':
        return Icons.kitchen_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }

  Future<void> chargerProduits() async {
    try {
      final produit = await _produitservice.getAllProduits();
      setState(() {
        _produits = produit;
        _searchResults = produit;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        setState(() {
          _searchResults = _produits;
        });
        return;
      }

      setState(() {
        _searchResults = _produits.where((produit) {
          final titreMatch = produit.nom.toLowerCase().contains(
            text.toLowerCase(),
          );
          final descMatch = produit.description.toLowerCase().contains(
            text.toLowerCase(),
          );
          return titreMatch || descMatch;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Constant.blue)),
      );
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
                  controller: _searchContoller,
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
                  onChanged: _onSearchTextChanged,
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
                  fontSize: 18,
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
                  final categorie = categories[i];
                  return CategoryChip(
                    nom: categorie.nom,
                    icon: categorie.icone ?? Icons.grid_view_rounded,
                    selected: i == _selectedCategory,
                    onTap: () => setState(() => _selectedCategory = i),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: categories.length,
                // itemCount: _categories.length,
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
                (context, index) {
                  // Liste source : produits normaux ou résultats de recherche
                  final List produitsAffiches = _searchContoller.text.isEmpty
                      ? _produits
                      : _searchResults;

                  // Si recherche active et aucun résultat
                  if (_searchContoller.text.isNotEmpty &&
                      produitsAffiches.isEmpty) {
                    return const Center(child: Text("Aucun produit trouvé"));
                  }

                  final produit = produitsAffiches[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(produit: produit),
                        ),
                      );
                    },
                    child: Productcard(produit: produit),
                  );
                },
                childCount: _searchContoller.text.isEmpty
                    ? _produits.length
                    : _searchResults.isEmpty
                    ? 1 // Pour afficher le message "Aucun produit trouvé"
                    : _searchResults.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
