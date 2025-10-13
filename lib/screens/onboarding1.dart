import 'package:flutter/material.dart';
import 'onboarding2.dart'; // <-- on importe la page 2

class Onboarding1Page extends StatelessWidget {
  const Onboarding1Page({super.key});

  // Palette issue de la maquette
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
                  'assets/image/onb1.png',
                  height: size.height * 0.38,
                  fit: BoxFit.contain,
                ),
              ),

              // Titre sur 2 lignes
              const SizedBox(height: 12),
              const Text(
                'Ensemble, on commande\nmieux !',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  height: 1.20,
                  fontWeight: FontWeight.w700,
                  color: _title,
                ),
              ),

              const SizedBox(height: 12),

              // Paragraphe
              const Text(
                'Finies les petites commandes non rentables !\n'
                    'Rejoignez d’autres commerçants pour acheter en\n'
                    'groupe et profiter de meilleurs prix.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.50,
                  color: _sub,
                ),
              ),

              const Spacer(),

              // Indicateurs (centrés)
              Padding(
                padding: const EdgeInsets.only(bottom: 150), // ⬆️ remonte légèrement
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _Dot(active: true),
                    SizedBox(width: 14),
                    _Dot(active: false),
                    SizedBox(width: 14),
                    _Dot(active: false),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bas de page: "Passer" + flèche
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Skip -> aller à la Home/Connexion
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
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {
                        // 👉 Navigation vers Onboarding 2
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Onboarding2Page()),
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
        color: active ? Onboarding1Page._blue : Onboarding1Page._beige,
      ),
    );
  }
}
