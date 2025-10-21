import 'package:flutter/material.dart';

class AnimatedBottomNavBar extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final double height;

  const AnimatedBottomNavBar({Key? key, required this.selectedIndex, required this.onDestinationSelected, this.height = 84}) : super(key: key);

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  late int _selected;

  final _labels = const ['Accueil', 'Fournisseurs', 'Commandes', 'Annuaire', 'Profil'];
  final _icons = const [
    'assets/icons/home.png',
    'assets/icons/store.png',
    'assets/icons/orders.png',
    'assets/icons/contacts.png',
    'assets/icons/profile.png',
  ];
  final _activeIcons = const [
    'assets/icons/home_active.png',
    'assets/icons/store_active.png',
    'assets/icons/orders_active.png',
    'assets/icons/contacts_active.png',
    'assets/icons/profile_active.png',
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedIndex;
  }

  void _onTap(int i) {
    setState(() => _selected = i);
    widget.onDestinationSelected(i);
  }

  @override
  Widget build(BuildContext context) {
    // No layout calculations needed for icon-only nav bar.

    return Material(
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            // No circular indicator: icons only

            Row(
              children: List.generate(_labels.length, (i) {
                final active = i == _selected;
                return Expanded(
                  child: InkWell(
                    onTap: () => _onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(active ? _activeIcons[i] : _icons[i], width: 28, height: 28),
                        const SizedBox(height: 6),
                        Text(
                          _labels[i],
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? const Color(0xFF2F80ED) : Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
