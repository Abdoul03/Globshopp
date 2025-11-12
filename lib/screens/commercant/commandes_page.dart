// lib/screens/commandes_page.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commandeGroupee.dart' as cg;
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/services/commandeGroupeeService.dart';

class CommandesPage extends StatefulWidget {
  const CommandesPage({super.key});

  @override
  State<CommandesPage> createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  final _searchCtrl = TextEditingController();
  String _q = '';
  final _storage = const FlutterSecureStorage();
  final _service = CommandeGroupeeService();
  List<Order> _orders = [];
  bool _loading = false;
  String? _error;

  Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  String? _extractIdFromToken(String accessToken) {
    try {
      final parts = accessToken.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final payloadMap = jsonDecode(utf8.decode(base64Url.decode(normalized)));
      if (payloadMap is! Map<String, dynamic>) return null;
      return payloadMap['sub']?.toString();
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadOrders() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await _getAccessToken();
      if (token == null) {
        throw Exception('Token manquant');
      }
      final idStr = _extractIdFromToken(token);
      if (idStr == null) {
        throw Exception('Token invalide');
      }
      final commercantId = int.tryParse(idStr);
      if (commercantId == null) {
        throw Exception('Identifiant commerçant invalide');
      }
      final List<cg.CommandeGroupee> data = await _service
          .getCommercantCommandesAll(commercantId);
      final mapped = data.map(_mapCommandeToOrder).toList();
      setState(() {
        _orders = mapped;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Order _mapCommandeToOrder(cg.CommandeGroupee c) {
    final Produit? p = c.produit;
    final String title = p?.nom ?? 'Produit';
    final String price = ((p?.prix ?? c.montant)).toString() + ' Fcfa';
    final int qty = c.quantiteRequis;
    final String imageUrl =
        p?.firstImageUrl ??
        'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=300';
    final String s = (c.status?.name ?? '').toUpperCase();
    OrderStatus status;
    switch (s) {
      case 'TERMINER':
        status = OrderStatus.done;
        break;
      case 'ANNULER':
        status = OrderStatus.canceled;
        break;
      case 'EXPEDIER':
        status = OrderStatus.inProgress;
        break;
      case 'ENCOURS':
      default:
        status = OrderStatus.inProgress;
    }
    return Order(
      title: title,
      price: price,
      status: status,
      qty: qty,
      imageUrl: imageUrl,
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_orders.isEmpty && !_loading && _error == null) {
      _loadOrders();
    }

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
            automaticallyImplyLeading: false,
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
          if (_loading)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (!_loading && _error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ),
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
      surfaceTintColor: Colors.transparent,
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
            borderSide: const BorderSide(color: Constant.grisClaire),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Constant.grisClaire),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Constant.grisClaire),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
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

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("En cours d'inplementation"),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _cardBorder),
          borderRadius: BorderRadius.circular(16),
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
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
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
