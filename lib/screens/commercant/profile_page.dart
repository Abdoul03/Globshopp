// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/screens/custom/circleImageButton.dart';
import 'package:globshopp/screens/custom/fieldLabel.dart';
import 'package:globshopp/screens/custom/infoTile.dart';
import 'package:globshopp/services/authentification.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Authentification _authentification = Authentification();
  bool isLoading = false;

  Future<void> logOut() async {
    setState(() {
      isLoading = true;
    });
    _authentification.logout();
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Deconnecter avec succes")));
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          // ====== SLIVER APP BAR avec icône modifier ======
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 64, //
            title: const Text(
              'Profil',
              style: TextStyle(
                color: Constant.colorsBlack,
                fontSize: 18, //
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleImageButton(
                  imagePath: 'assets/icons/edit.png',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Modifier le profil')),
                    );
                  },
                ),
              ),
            ],
          ),

          // ====== CONTENU ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  const SizedBox(height: 4),
                  Center(
                    child: CircleAvatar(
                      radius: 42, // 🔹 légèrement plus petit
                      backgroundColor: const Color(0xFFE8EEF9),
                      child: ClipOval(
                        child: Image.network(
                          'https://i.imgur.com/9DKYzjK.jpeg',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 48,
                            color: Constant.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Champs info
                  FieldLabel('Nom'),
                  InfoTile(
                    icon: Icons.person_outline_rounded,
                    text: 'Abdoul Ibrahima Samaké',
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Téléphone'),
                  InfoTile(icon: Icons.phone_outlined, text: '71267813'),
                  const SizedBox(height: 12),

                  FieldLabel('Email'),
                  InfoTile(
                    icon: Icons.mail_outline_rounded,
                    text: 'Samabdoul03@gmail.com',
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Rôle'),
                  InfoTile(icon: Icons.vpn_key_outlined, text: 'Commerçant'),
                  const SizedBox(height: 12),

                  FieldLabel('Adresse'),
                  InfoTile(
                    icon: Icons.location_city_outlined,
                    text: 'Bamako / Mali / Grand marché',
                  ),

                  const SizedBox(height: 24),

                  // Bouton Déconnexion
                  SizedBox(
                    width: double.infinity,
                    height: 46, // 🔹 plus fin
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Constant.rougeTransparant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: logOut,
                      child: isLoading
                          ? CircularProgressIndicator(color: Constant.rougeVif)
                          : const Text(
                              'Déconnexion',
                              style: TextStyle(
                                color: Constant.rougeVif,
                                fontSize: 14.5, // 🔹 réduit
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
