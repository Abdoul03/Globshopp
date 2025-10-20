// lib/screens/notifications_page.dart
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // Palette
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF9AA0A6);
  static const _divider = Color(0xFFEAEAEA);
  static const _greenDot = Color(0xFF31D158);

  @override
  Widget build(BuildContext context) {
    // Données d’exemple
    const itemMsg =
        'Votre commande groupée de T-shirts coton “Everyday fit” a été confirmer par le fournisseur';
    const itemTime = 'Il ya 4 minutes';

    final unread = List.generate(3, (_) => const _NotifData(itemMsg, itemTime, true));
    final today = List.generate(4, (_) => const _NotifData(itemMsg, itemTime, false));
    final yesterday = List.generate(3, (_) => const _NotifData(itemMsg, itemTime, false));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              titleSpacing: 0,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _text),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _text,
                    ),
                  ),
                ],
              ),
            ),

            // Section: Non lue
            const _SectionHeader('Non lue'),
            _SectionList(items: unread),

            // Section: Aujourd’hui
            const _SectionHeader('Aujourd’hui'),
            _SectionList(items: today),

            // Section: Hiere (orthographe de la maquette)
            const _SectionHeader('Hiere'),
            _SectionList(items: yesterday),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/* ======================= Widgets ======================= */

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: NotificationsPage._text,
          ),
        ),
      ),
    );
  }
}

class _SectionList extends StatelessWidget {
  const _SectionList({required this.items});
  final List<_NotifData> items;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Divider(height: 1, thickness: 1, color: NotificationsPage._divider),
      ),
      itemBuilder: (context, i) => _NotificationTile(data: items[i]),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.data});
  final _NotifData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colonne texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    color: NotificationsPage._text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: NotificationsPage._sub,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Point vert (non lu)
          if (data.unread)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: _Dot(),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: NotificationsPage._greenDot,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NotifData {
  const _NotifData(this.message, this.time, this.unread);
  final String message;
  final String time;
  final bool unread;
}
