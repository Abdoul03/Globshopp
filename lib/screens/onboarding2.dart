// lib/screens/onboarding2.dart
import 'package:flutter/material.dart';
import 'onboarding3.dart'; // ✅ on importe la page 3 ici

class Onboarding2Page extends StatelessWidget {
  const Onboarding2Page({super.key});

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
                  'assets/image/onb2.png',
                  height: isShort ? size.height * 0.33 : size.height * 0.40,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: isShort ? 18 : 28),

              // Titre
              const Text(
                'Payez en toute confiance !',
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
                'Vos paiements sont sécurisés et 100% traçables.\n'
                    'Profitez d’une transparence totale à chaque\n'
                    'transaction.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.50,
                  color: _sub,
                ),
              ),

              const Spacer(),

              // Indicateurs (2e actif)
              Padding(
                padding: const EdgeInsets.only(bottom: 150.0), // ⬆️ remonte légèrement
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // optionnel : centre horizontalement
                  children: const [
                    _Dot(active: false),
                    SizedBox(width: 15),
                    _Dot(active: true),
                    SizedBox(width: 15),
                    _Dot(active: false),
                  ],
                ),
              ),

              // Bas de page
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
                        // 👉 Navigation vers Onboarding3
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Onboarding3Page(),
                          ),
                        );
                        // ou:
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => const Onboarding3Page()),
                        // );
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
        color: active ? Onboarding2Page._blue : Onboarding2Page._beige,
      ),
    );
  }
}


