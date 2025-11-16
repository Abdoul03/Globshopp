// lib/screens/profile_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/screens/custom/circleImageButton.dart';
import 'package:globshopp/screens/custom/fieldLabel.dart';
import 'package:globshopp/screens/custom/infoTile.dart';
import 'package:globshopp/services/authentification.dart';
import 'package:globshopp/services/commercantService.dart';
import 'package:globshopp/screens/commercant/edit_profile_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = FlutterSecureStorage();
  final Authentification _authentification = Authentification();
  final CommercantService _commercantService = CommercantService();

  Commercant? commercant;

  bool isLoading = false;

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  String? extractIdFromToken(String accessToken) {
    try {
      // Le token a la forme header.payload.signature
      final parts = accessToken.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      // Base64Url decoding
      var normalized = base64Url.normalize(payload);
      final payloadMap = jsonDecode(utf8.decode(base64Url.decode(normalized)));

      if (payloadMap is! Map<String, dynamic>) return null;
      return payloadMap['sub'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> getUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Token non trouvé, veuillez vous reconnecter",
              style: TextStyle(color: Constant.colorsWhite),
            ),
            backgroundColor: Constant.blue,
          ),
        );
        return;
      }
      final id = extractIdFromToken(accessToken);
      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Token invalide, veuillez vous reconnecter",
              style: TextStyle(color: Constant.colorsWhite),
            ),
            backgroundColor: Constant.blue,
          ),
        );
        return;
      }
      final conversionId = int.tryParse(id);
      if (conversionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "ID utilisateur invalide",
              style: TextStyle(color: Constant.colorsWhite),
            ),
            backgroundColor: Constant.blue,
          ),
        );
        return;
      }
      final user = await _commercantService.getCommercant(conversionId);
      setState(() {
        commercant = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

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
  void initState() {
    getUser();
    super.initState();
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
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(commercant: commercant),
                      ),
                    );
                    if (updated is Commercant) {
                      setState(() {
                        commercant = updated;
                      });
                    } else {
                      await getUser();
                    }
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
                    text:
                        '${commercant?.prenom ?? ""} ${commercant?.nom ?? ""}',
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Téléphone'),
                  InfoTile(
                    icon: Icons.phone_outlined,
                    text: commercant?.telephone ?? "",
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Email'),
                  InfoTile(
                    icon: Icons.mail_outline_rounded,
                    text: commercant?.email ?? "",
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Rôle'),
                  InfoTile(
                    icon: Icons.vpn_key_outlined,
                    text: "${commercant?.role!.name}",
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Adresse'),
                  InfoTile(
                    icon: Icons.location_city_outlined,
                    text: 'Bamako / Mali',
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
