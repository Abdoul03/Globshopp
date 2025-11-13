import 'package:flutter/material.dart';
import 'package:globshopp/screens/commercant/commandes_page.dart' show Order, OrderStatus;

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order});

  final Order order;

  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE9E9EE);

  static const _pillInBg = Color(0xFFDFF2DB);
  static const _pillInFg = Color(0xFF2A9A49);
  static const _pillCaBg = Color(0xFFFAD7DA);
  static const _pillCaFg = Color(0xFFD44755);
  static const _pillDoBg = Color(0xFFDCE6F7);
  static const _pillDoFg = Color(0xFF5D7EB7);
  static const _deadlineBg = Color(0xFFFAD7DA);
  static const _deadlineFg = Color(0xFFD44755);

  (String, Color, Color) _statusStyle(OrderStatus s) {
    switch (s) {
      case OrderStatus.inProgress:
        return ('En cours', _pillInBg, _pillInFg);
      case OrderStatus.canceled:
        return ('Annuler', _pillCaBg, _pillCaFg);
      case OrderStatus.done:
        return ('Terminer', _pillDoBg, _pillDoFg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _statusStyle(order.status);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 172, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Carte produit + statut
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        color: Color(0x0F000000),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order.imageUrl,
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 84,
                            height: 84,
                            color: const Color(0xFFEFF1F6),
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            const SizedBox(height: 6),
                            Text(
                              'Le Auralis X9 Pro combine élégance et performance dans un design minimaliste.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12.5, color: _sub),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  height: 26,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 26,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: _deadlineBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'DeadLine: 20/11/2025',
                                    style: TextStyle(
                                      color: _deadlineFg,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // KPI MOQ / Price
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF6E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Minimum order Quantity',
                              style: TextStyle(color: _sub, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '144 pieces',
                              style: TextStyle(
                                color: Color(0xFFEB8A1A),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(color: _sub, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '140.000fcfa',
                              style: TextStyle(
                                color: Color(0xFFEB8A1A),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Quantité actuelle (statique)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text('Quantité actuelle', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      Text('100 pieces', style: TextStyle(color: Color(0xFF246BEB), fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Liste des membres
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
                        child: Text('Liste des membres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                      const _MemberTile(
                        name: 'Aminata Diallo',
                        since: '22/03/2025',
                        pieces: 60,
                        avatarUrl: 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=100',
                      ),
                      const _MemberTile(
                        name: 'Aminata Diallo',
                        since: '22/03/2025',
                        pieces: 60,
                        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
                      ),
                      const _MemberTile(
                        name: 'Aminata Diallo',
                        since: '22/03/2025',
                        pieces: 60,
                        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF246BEB),
                            side: BorderSide(color: Color(0xFF246BEB)),
                          ),
                          child: const Text('Voir plus'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // A propos du fournisseur (statique)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'A propos du fournisseur',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=160',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Mariam Koné',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 4),
                                Text('Membre depuis 23/11/2022', style: TextStyle(color: _sub)),
                                SizedBox(height: 8),
                                Text(
                                  'Curabitur luctus odio vel lorem vestibulum, vitae tincidunt leo posuere. Fusce ultricies, mi non volutpat cursus, lacus est dignissim metus, vel finibus risus tortor ac nisl.',
                                  style: TextStyle(color: _sub),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // En-tête
          Container(
            height: 160,
            width: double.infinity,
            color: const Color(0xFF246BEB),
            padding: const EdgeInsets.only(top: 44, left: 12, right: 12),
            child: Row(
              children: const [
                BackButton(color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Information sur la commande',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.name,
    required this.since,
    required this.pieces,
    required this.avatarUrl,
  });

  final String name;
  final String since;
  final int pieces;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  'Membre depuis : $since',
                  style: const TextStyle(color: OrderDetailPage._sub),
                ),
              ],
            ),
          ),
          Text(
            '$pieces pieces',
            style: const TextStyle(
              color: Color(0xFFEB8A1A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
