// lib/screens/commandes_page.dart
import 'package:flutter/material.dart';

class CommandesPage extends StatefulWidget {
  const CommandesPage({super.key});

  @override
  State<CommandesPage> createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE9E9EE);

  // Onglet actif = Commandes
  int _currentIndex = 2;

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
      status: OrderStatus.canceled,
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
      status: OrderStatus.inProgress,
      qty: 144,
      imageUrl:
      'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Espace status bar
          SliverToBoxAdapter(child: SizedBox(height: top + 8)),
          // Bouton recherche à droite
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Row(
                children: [
                  const Spacer(),
                  _roundButton(
                    icon: Icons.search_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          // Liste de commandes
          SliverList.separated(
            itemCount: _orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OrderCard(order: _orders[i]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),

      // ------------------ NAVIGATION BAR BOTTOM (même que Accueil) ------------------
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
            // Accueil
            if (i == 0) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/accueil',
                    (route) => false,
              );
              return;
            }
            // Commandes (déjà ici)
            if (i == 2) {
              return;
            }
            // Autres onglets : maj visuelle (tu pourras brancher les routes plus tard)
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

  Widget _roundButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(color: _cardBorder),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: _text),
        ),
      ),
    );
  }
}

/* --------------------- MODELES --------------------- */

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

/// Icône image (même helper que sur Accueil)
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 26, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}
