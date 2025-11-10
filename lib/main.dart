// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:globshopp/screens/onboarding_carousel.dart';
import 'package:globshopp/screens/auth/login_page.dart';
import 'package:globshopp/screens/commercant/accueil.dart';
import 'package:globshopp/screens/commercant/fournisseurs_page.dart';
import 'package:globshopp/screens/commercant/commandes_page.dart';
import 'package:globshopp/screens/commercant/annuaire_page.dart';
import 'package:globshopp/screens/commercant/profile_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// void main() => runApp(const GlobalShopperApp());
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(GlobalShopperApp());
}

class GlobalShopperApp extends StatelessWidget {
  const GlobalShopperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Global Shopper',
      theme: ThemeData(useMaterial3: true),
      home: OnboardingCarousel(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/login': (_) => const LoginPage(),
        '/accueil': (_) => const HomePage(),
        '/fournisseurs': (_) => const FournisseursPage(),
        '/commandes': (_) => const CommandesPage(),
        '/annuaire': (_) => const AnnuairePage(),
        '/profil': (_) => const Profile(),
      },
    );
  }
}
