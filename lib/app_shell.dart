// lib/screens/app_shell.dart
import 'package:flutter/material.dart';

// 🧩 Importation des onglets (contenus sans Scaffold)
import 'package:globshopp/screens/tabs/home_tab.dart';
import 'package:globshopp/screens/tabs/fournisseurs_tab.dart';
import 'package:globshopp/screens/tabs/commandes_tab.dart';
import 'package:globshopp/screens/tabs/annuaire_tab.dart';
import 'package:globshopp/screens/tabs/profil_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  // Permet d’accéder facilement à AppShell.of(context)?.setTab(i)
  static _AppShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppShellState>();

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _blue = Color(0xFF2F80ED);
  int _index = 0; // Onglet actif

  // ⚡️ Conserve l’état des pages (scroll, champ texte…)
  final _bucket = PageStorageBucket();

  // 🔹 Liste des onglets (sans Scaffold)
  final _tabs = const [
    HomeTab(key: PageStorageKey('home')),
    FournisseursTab(key: PageStorageKey('fournisseurs')),
    CommandesTab(key: PageStorageKey('commandes')),
    AnnuaireTab(key: PageStorageKey('annuaire')),
    ProfilTab(key: PageStorageKey('profil')),
  ];

  // 🔄 Méthode pour changer d’onglet
  void setTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 💡 Contenu principal : IndexedStack garde chaque page en mémoire
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _index,
          children: _tabs,
        ),
      ),

      // ⚙️ Barre de navigation inférieure partagée
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
          onDestinationSelected: setTab,
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

// 🖼️ Helper pour charger les icônes de la barre de navigation
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;

  const _NavIcon(this.path, {this.size = 26, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
