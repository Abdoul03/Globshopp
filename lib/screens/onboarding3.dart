import 'package:flutter/material.dart';
import 'role_selection_page.dart'; // ✅ destination

class Onboarding3Page extends StatelessWidget {
  const Onboarding3Page({super.key});

  // Palette
  static const _blue  = Color(0xFF2F80ED);
  static const _beige = Color(0xFFEEDFC2);
  static const _title = Color(0xFF0B0B0B);
  static const _sub   = Color(0xFF5C5F66);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShort = size.height < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isShort ? 12 : 24),

              // Illustration
              Center(
                child: Image.asset(
                  'assets/image/onb3.png',
                  height: isShort ? size.height * 0.33 : size.height * 0.40,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: isShort ? 18 : 28),

              // Titre
              const Text(
                'Le monde à portée de main !',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.20,
                  fontWeight: FontWeight.w700,
                  color: _title,
                ),
              ),

              const SizedBox(height: 16),

              // Paragraphe
              const Text(
                'Accédez directement aux meilleurs fournisseurs.\n'
                    'Découvrez et commandez des produits du\n'
                    'monde entier.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.50,
                  color: _sub,
                ),
              ),

              const Spacer(),

              // Indicateurs (3e actif)
              Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _Dot(active: false),
                    SizedBox(width: 14),
                    _Dot(active: false),
                    SizedBox(width: 14),
                    _Dot(active: true),
                  ],
                ),
              ),

              // Bas de page
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Skip -> Home/Connexion
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(64, 40),
                    ),
                    child: const Text(
                      'Passer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _blue,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _blue,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x332F80ED),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        // ✅ Aller à la sélection de rôle et retirer l’onboarding de la pile
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Onboarding3Page._blue : Onboarding3Page._beige,
      ),
    );
  }
}
