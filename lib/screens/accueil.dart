// lib/screens/accueil.dart
import 'package:flutter/material.dart';

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

  final List<CategoryItem> _categories = const [
    CategoryItem(label: 'Tous', icon: Icons.grid_view_rounded),
    CategoryItem(label: 'Accessoires', icon: Icons.headphones_rounded),
    CategoryItem(label: 'Electronique', icon: Icons.devices_other_rounded),
    CategoryItem(label: 'Habits', icon: Icons.checkroom_rounded),
    CategoryItem(label: 'Electro', icon: Icons.kitchen_rounded),
  ];

  final List<Product> _products = const [
    Product(
      title: 'T-shirts coton “Everyday Fit”',
      price: '1000 FCFA',
      moq: 'MOQ : 20 pieces',
      brand: 'Baba Fashion',
      image: 'assets/image/tshirt.png',
      badge: 'Disponible',
    ),
    Product(
      title: 'T-shirts coton “Everyday Fit”',
      price: '1000 FCFA',
      moq: 'MOQ : 20 pieces',
      brand: 'Baba Fashion',
      image: 'assets/image/tshirt.png',
    ),
    Product(
      title: 'Casques JBL live 770nc',
      price: '1000 FCFA',
      moq: 'MOQ : 100 pieces',
      brand: '',
      image: 'assets/image/jbl.png',
    ),
    Product(
      title: 'Casques JBL live 770nc',
      price: '1000 FCFA',
      moq: 'MOQ : 100 pieces',
      brand: '',
      image: 'assets/image/jbl.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: topSafe)),

          // En-tête
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  CircleAvatar(
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
                  const Spacer(),
                  _roundIcon(Icons.notifications_none_rounded),
                  const SizedBox(width: 12),
                  _roundIcon(Icons.history_rounded),
                ],
              ),
            ),
          ),

          // Barre de recherche
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
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

          // Titre "Catégories"
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
            ),
          ),

          // Chips Catégories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 92,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  final item = _categories[i];
                  return CategoryChip(
                    label: item.label,
                    icon: item.icon,
                    selected: i == 0,
                    onTap: () {},
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: _categories.length,
              ),
            ),
          ),

          // Grille produits  ✅ SliverPadding utilise "sliver:"
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
                  final p = _products[index];
                  return ProductCard(product: p);
                },
                childCount: _products.length,
              ),
            ),
          ),
        ],
      ),

      // Bottom bar avec icônes images
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onChanged: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  Widget _roundIcon(IconData icon) {
    return Ink(
      width: 40,
      height: 40,
      decoration: const ShapeDecoration(
        color: Color(0xFFF6F7FB),
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: _text),
      ),
    );
  }
}

/// ======== Modèles & Widgets ========

class CategoryItem {
  final String label;
  final IconData icon;
  const CategoryItem({required this.label, required this.icon});
}

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
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3CC36C),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text(
                            'Disponible',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.price,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    product.moq,
                    style: const TextStyle(
                        fontSize: 11.5, color: _HomePageState._sub),
                  ),
                ],
              ),
              if (product.brand.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  product.brand,
                  style: const TextStyle(
                      fontSize: 11.5, color: _HomePageState._sub),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  const _BottomNav({required this.currentIndex, required this.onChanged});

  static const double _iconSize = 24;

  Widget _img(String path) => Image.asset(
    path,
    width: _iconSize,
    height: _iconSize,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) =>
    const Icon(Icons.image_not_supported_outlined, size: _iconSize),
  );

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onChanged,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _HomePageState._blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: _img('assets/icons/home.png'),
          activeIcon: _img('assets/icons/home_active.png'),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: _img('assets/icons/store.png'),
          activeIcon: _img('assets/icons/store_active.png'),
          label: 'Fournisseurs',
        ),
        BottomNavigationBarItem(
          icon: _img('assets/icons/orders.png'),
          activeIcon: _img('assets/icons/orders_active.png'),
          label: 'Commandes',
        ),
        BottomNavigationBarItem(
          icon: _img('assets/icons/contacts.png'),
          activeIcon: _img('assets/icons/contacts_active.png'),
          label: 'Annuaire',
        ),
        BottomNavigationBarItem(
          icon: _img('assets/icons/profile.png'),
          activeIcon: _img('assets/icons/profile_active.png'),
          label: 'Profil',
        ),
      ],
    );
  }
}
