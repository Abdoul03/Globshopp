// lib/main.dart
import 'package:flutter/material.dart';
import 'package:globshopp/screens/fournisseur/navigationBar.dart';
import 'package:globshopp/screens/onboarding_carousel.dart';
import 'package:globshopp/screens/login_page.dart';
import 'package:globshopp/screens/accueil.dart';
import 'package:globshopp/screens/commandes_page.dart'; // ← ajoute la page Commandes

void main() {
  runApp(const GlobalShopperApp());
}

class GlobalShopperApp extends StatelessWidget {
  const GlobalShopperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Global Shopper',
      theme: ThemeData(useMaterial3: true),

      // Écran de démarrage
      // home: const OnboardingCarousel(),
      home: Navigationbar(),

      // ✅ Routes nommées accessibles partout
      routes: {
        '/login': (_) => const LoginPage(),
        '/accueil': (_) => const HomePage(),
        '/commandes': (_) => const CommandesPage(),
      },

      // (optionnel) Si une route inconnue est demandée
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomePage(),
        settings: const RouteSettings(name: '/accueil'),
      ),
    );
  }
}
