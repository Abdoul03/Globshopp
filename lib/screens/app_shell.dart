import 'package:flutter/material.dart';
import 'accueil_tab.dart';
import 'commandes_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _blue = Color(0xFF2F80ED);

  final _tabs = const <Widget>[
    AccueilTab(),          // 0
    Placeholder(),         // 1 Fournisseurs (à remplacer)
    CommandesPage(),       // 2
    Placeholder(),         // 3 Annuaire (à remplacer)
    Placeholder(),         // 4 Profil (à remplacer)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),

      // UNE SEULE barre pour toute l’app
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
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
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
              selectedIcon: _NavIcon('assets/icons/contacts_active.png', size: 28),
              label: 'Annuaire',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/profile.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/profile_active.png', size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 26, super.key});
  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}
