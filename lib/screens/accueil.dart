// lib/screens/accueil.dart
import 'package:flutter/material.dart';
import 'package:globshopp/widgets/animated_bottom_nav.dart';
import 'product_detail_page.dart';               // déjà présent
import 'notifications_page.dart';               // ✅ AJOUT: page des notifications
// import 'package:globshopp/_base/constant.dart'; // inutilisé ici

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🎨 Palette
  static const _blue       = Color(0xFF2F80ED);
  static const _yellow     = Color(0xFFE9AB30);
  static const _text       = Color(0xFF0B0B0B);
  static const _sub        = Color(0xFF5C5F66);
  static const _chipBg     = Color(0xFFF7F7F9);
  static const _cardBorder = Color(0xFFEDEDED);

  int _selectedCategory = 0;

  final _categories = const [
    ('Tous', Icons.grid_view_rounded),
    ('Accessoires', Icons.headphones_rounded),
    ('Electronique', Icons.devices_other_rounded),
    ('Habits', Icons.checkroom_rounded),
    ('Electro', Icons.kitchen_rounded),
  ];

  final _products = const [
    Product(
      title: 'T-shirts coton “Everyday Fit”',
      price: '1000 FCFA',
      moq: 'MOQ: 20 pcs',
      brand: 'Baba Fashion',
      image: 'assets/image/tshirt.png',
      badge: 'Disponible',
    ),
    Product(
      title: 'T-shirts coton “Everyday Fit”',
      price: '1000 FCFA',
      moq: 'MOQ: 20 pcs',
      brand: 'Baba Fashion',
      image: 'assets/image/tshirt.png',
      badge: 'Disponible',
    ),
    Product(
      title: 'T-shirts coton “Everyday Fit”',
      price: '1000 FCFA',
      moq: 'MOQ: 20 pcs',
      brand: 'Baba Fashion',
      image: 'assets/image/tshirt.png',
      badge: 'Disponible',
    ),
    Product(
      title: 'T-shirts coton “Everyday Fit”',
      price: '1000 FCFA',
      moq: 'MOQ: 20 pcs',
      brand: 'Baba Fashion',
      image: 'assets/image/tshirt.png',
      badge: 'Disponible',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

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
              // ✅ Quand on appuie, on ouvre NotificationsPage
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsPage()),
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
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: _blue),
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
                  color: _text,
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
                    (context, index) => ProductCard(product: _products[index]),
                childCount: _products.length,
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

// --------- Classes & Widgets ---------

class Product {
  final String title;
  final String price;
  final String moq;
  final String brand;
  final String image;
  final String? badge;

  const Product({
    required this.title,
    required this.price,
    required this.moq,
    required this.brand,
    required this.image,
    this.badge,
  });
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected ? _HomePageState._blue : Colors.black12;
    final fill = selected ? const Color(0xFFEAF1FF) : _HomePageState._chipBg;
    final Color iconColor =
    selected ? _HomePageState._blue : _HomePageState._yellow;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Center(child: Icon(icon, size: 26, color: iconColor)),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _HomePageState._text,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        // ✅ Vers le détail produit
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _HomePageState._cardBorder),
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
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.image_outlined, size: 36)),
                          ),
                        ),
                      ),
                    ),
                    if (product.badge != null)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3CC36C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: _HomePageState._text,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.price,
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
                        product.moq,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _HomePageState._sub,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                product.brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: _HomePageState._sub,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// ---------------- Custom Animated Bottom Nav Bar ----------------

// The bottom navigation implementation is now provided by the reusable
// `AnimatedBottomNavBar` widget in `lib/widgets/animated_bottom_nav.dart`.
