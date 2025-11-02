import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:globshopp/screens/custom/circleImageButton.dart';
import 'package:globshopp/screens/custom/fieldLabel.dart';
import 'package:globshopp/screens/custom/infoTile.dart';
import 'package:globshopp/services/authentification.dart';
import 'package:globshopp/services/fournisseurService.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final storage = FlutterSecureStorage();
  final FournisseurService _fournisseurService = FournisseurService();
  final Authentification _authentification = Authentification();
  bool isLoading = false;

  Fournisseur? fournisseur;

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

  Future<void> getUserInformation() async {
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
      final user = await _fournisseurService.getFournisseur(conversionId!);
      setState(() {
        fournisseur = user;
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
    getUserInformation();
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
            toolbarHeight: 64, // 🔹 plus compact
            title: const Text(
              'Profil',
              style: TextStyle(
                color: Constant.colorsBlack,
                fontSize: 18, // 🔹 taille réduite
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
                    text:
                        "${fournisseur?.prenom ?? ""} ${fournisseur?.nom ?? ""}",
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Téléphone'),
                  InfoTile(
                    icon: Icons.phone_outlined,
                    text: fournisseur?.telephone ?? "",
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Email'),
                  InfoTile(
                    icon: Icons.mail_outline_rounded,
                    text: fournisseur?.email ?? "",
                  ),
                  const SizedBox(height: 12),

                  FieldLabel('Rôle'),
                  InfoTile(
                    icon: Icons.vpn_key_outlined,
                    text: "${fournisseur?.role ?? ""}",
                  ),
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
                                fontSize: 14.5, //
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
