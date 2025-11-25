import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/screens/commercant/accueil.dart';
import 'package:globshopp/screens/commercant/annuaire_page.dart';
import 'package:globshopp/screens/commercant/commandes_page.dart';
import 'package:globshopp/screens/commercant/fournisseurs_page.dart';
import 'package:globshopp/screens/commercant/profile_page.dart';
import 'package:remixicon/remixicon.dart';

class Commercantnavigation extends StatefulWidget {
  const Commercantnavigation({super.key});

  @override
  State<Commercantnavigation> createState() => _CommercantnavigationState();
}

class _CommercantnavigationState extends State<Commercantnavigation> {
  int _selectedIndex = 0;

  final appScreens = [
    HomePage(),
    FournisseursPage(),
    CommandesPage(),
    AnnuairePage(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: appScreens[_selectedIndex],
      ),
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
            icon: Icon(RemixIcons.home_2_line),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.store_3_line),
            label: "Fournisseur",
          ),
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.box_3_line),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(RemixIcons.book_3_line),
            label: "Transitaires",
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
