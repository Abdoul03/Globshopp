// lib/screens/commandes_page.dart
import 'package:flutter/material.dart';

class CommandesPage extends StatefulWidget {
  const CommandesPage({super.key});

  @override
  State<CommandesPage> createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  // Palette & styles
  // couleurs locales supprimées (utiliser `Constant` si besoin)

  // Onglet actif
  int _currentIndex = 2;

  final _searchCtrl = TextEditingController();
  String _q = '';

  // ✅ Seulement 2 commandes
  final _orders = const [
    Order(
      title: 'T-shirts coton “Everyday fit”',
      price: '1000 Fcfa',
      status: OrderStatus.inProgress,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
    Order(
      title: 'T-shirts coton “Everyday fit”',
      price: '1000 Fcfa',
      status: OrderStatus.done,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
    Order(
      title: 'T-shirts coton “Everyday fit”',
      price: '1000 Fcfa',
      status: OrderStatus.done,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
    Order(
      title: 'T-shirts coton “Everyday fit”',
      price: '1000 Fcfa',
      status: OrderStatus.done,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
    Order(
      title: 'T-shirts coton “Everyday fit”',
      price: '1000 Fcfa',
      status: OrderStatus.done,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
    Order(
      title: 'T-shirts coton “Everyday fit”',
      price: '1000 Fcfa',
      status: OrderStatus.done,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  // final top = MediaQuery.of(context).padding.top; // inutilisé

    final filtered = _orders.where((o) {
      if (_q.isEmpty) return true;
      final q = _q.toLowerCase();
      return o.title.toLowerCase().contains(q) ||
          o.price.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --------- Header Recherche ---------
          SliverAppBar(
            automaticallyImplyLeading: false, // 🚫 enlève le bouton retour auto
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 90,
            title: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _SearchField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _q = v.trim()),
              ),
            ),
          ),


          // --------- Liste des commandes (filtrée) ---------
          SliverList.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OrderCard(order: filtered[i]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),

      // ------------------ NAVIGATION BAR ------------------
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
            if (i == _currentIndex) return;
            switch (i) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(
                    context, '/accueil', (r) => false);
                break;
              case 1:
                Navigator.pushNamed(context, '/fournisseurs');
                break;
              case 2:
                break; // déjà ici
              case 3:
                Navigator.pushNamed(context, '/annuaire');
                break;
              case 4:
                Navigator.pushNamed(context, '/profil');
                break;
            }
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

/* --------------------- MODÈLES --------------------- */

enum OrderStatus { inProgress, canceled, done }

class Order {
  final String title;
  final String price;
  final OrderStatus status;
  final int qty;
  final String imageUrl;

  const Order({
    required this.title,
    required this.price,
    required this.status,
    required this.qty,
    required this.imageUrl,
  });
}

/* --------------------- WIDGETS --------------------- */

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
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

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final Order order;

  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE9E9EE);

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _statusStyle(order.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 1),
            color: Color(0x0F000000),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar produit
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              order.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: const Color(0xFFEFF1F6),
                child: const Icon(Icons.image_outlined),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Titre, prix, état
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.price,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: _sub,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _StatusPill(label: label, bg: bg, fg: fg),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Pastille quantité
          _QtyBadge(qty: order.qty),
        ],
      ),
    );
  }

  /// Renvoie label + couleurs (fond/texte) selon le statut
  static (String, Color, Color) _statusStyle(OrderStatus s) {
    switch (s) {
      case OrderStatus.inProgress:
        return ('Encours', const Color(0xFFDFF2DB), const Color(0xFF2A9A49));
      case OrderStatus.canceled:
        return ('Annuler', const Color(0xFFFAD7DA), const Color(0xFFD44755));
      case OrderStatus.done:
        return ('Terminer', const Color(0xFFDCE6F7), const Color(0xFF5D7EB7));
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _QtyBadge extends StatelessWidget {
  const _QtyBadge({required this.qty});
  final int qty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFDEBD0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '$qty',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFFCC9A3B),
        ),
      ),
    );
  }
}

/// Icône image (mêmes assets que tes autres écrans)
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {Key? key, this.size = 26}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}
