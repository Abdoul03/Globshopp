// lib/screens/accueil.dart
import 'package:flutter/material.dart';
import 'package:globshopp/screens/_base/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🎨 Palette
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _chipBg = Color(0xFFF7F7F9);
  static const _cardBorder = Color(0xFFEDEDED);

  int _currentIndex = 0;

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
    ),
    Product(
      title: 'Casques JBL live 770nc',
      price: '1000 FCFA',
      moq: 'MOQ: 100 pcs',
      brand: '',
      image: 'assets/image/jbl.png',
    ),
    Product(
      title: 'Casques JBL live 770nc',
      price: '1000 FCFA',
      moq: 'MOQ: 100 pcs',
      brand: '',
      image: 'assets/image/jbl.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ------------------ CONTENU ------------------
      body: CustomScrollView(
        slivers: [
          // En-tête + recherche
          SliverAppBar(
            surfaceTintColor: Constant.colorsWhite,
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
                  width: 22,
                  height: 22,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.shopping_cart_outlined, size: 18),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                ),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
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

          // Titre
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Text(
                'Catégories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
            ),
          ),

          // Chips catégories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 92,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  final (label, icon) = _categories[i];
                  return CategoryChip(
                    label: label,
                    icon: icon,
                    selected: i == 0,
                    onTap: () {},
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: _categories.length,
              ),
            ),
          ),

          // Grille produits
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final p = _products[index];
                return ProductCard(product: p);
              }, childCount: _products.length),
            ),
          ),
        ],
      ),

      // ------------------ NAVIGATION BAR BOTTOM ------------------
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
            // Accueil : on reste sur HomePage
            if (i == 0) {
              setState(() => _currentIndex = 0);
              return;
            }
            // ✅ Commandes → ouvre via route nommée (déclarée dans main.dart)
            if (i == 2) {
              Navigator.pushNamed(context, '/commandes');
              return;
            }
            // Autres onglets : MAJ visuelle
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
              selectedIcon: _NavIcon(
                'assets/icons/orders_active.png',
                size: 28,
              ),
              label: 'Commandes',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/contacts.png', size: 28),
              selectedIcon: _NavIcon(
                'assets/icons/contacts_active.png',
                size: 28,
              ),
              label: 'Annuaire',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/profile.png', size: 28),
              selectedIcon: _NavIcon(
                'assets/icons/profile_active.png',
                size: 28,
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

//// --------- MODELES & WIDGETS ---------

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
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected ? _HomePageState._blue : Colors.black12;
    final fill = selected ? const Color(0xFFEAF1FF) : _HomePageState._chipBg;
    final iconColor = selected ? _HomePageState._blue : _HomePageState._text;

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 92,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
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
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _HomePageState._cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + badge
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
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_outlined, size: 36),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (product.badge != null)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
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
              const SizedBox(height: 10),

              // Titre
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

              // Prix + MOQ
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

              if (product.brand.isNotEmpty) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Icône image pour NavigationBar (const-friendly)
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 26, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}
