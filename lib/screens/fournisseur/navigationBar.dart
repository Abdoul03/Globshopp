import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/screens/fournisseur/ajoutPoduit.dart';
import 'package:globshopp/screens/fournisseur/article.dart';
import 'package:globshopp/screens/fournisseur/commande.dart';
import 'package:globshopp/screens/fournisseur/profil.dart';
import 'package:remixicon/remixicon.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int _selectedIndex = 0;

  final appScreens = [Article(), Ajoutpoduit(), Commande(), Profil()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: appScreens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Important !
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Constant.colorsWhite,
        selectedItemColor: Constant.blue,
        unselectedItemColor: Constant.colorsgray,
        iconSize: 34,
        items: [
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.shopping_cart_line),
            label: "Articles",
          ),
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.add_line),
            label: "Ajouter",
          ),
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.box_3_line),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.user_6_line),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
