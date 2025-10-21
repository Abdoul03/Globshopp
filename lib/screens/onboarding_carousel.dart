// lib/screens/onboarding_carousel.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//destination finale après l’onboarding
import 'role_selection_page.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _controller = PageController();
  int _current = 0;

  // Palette (reprend tes couleurs)
  static const _blue = Color(0xFF2F80ED);
  static const _beige = Color(0xFFEEDFC2);
  static const _title = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);

  // Les 3 slides équivalents à tes Onboarding1/2/3
  final List<_SlideData> _slides = const [
    _SlideData(
      image: 'assets/image/onb1.png',
      title: 'Ensemble, on commande\nmieux !',
      text:
          'Finie les petites commandes non rentables !\n'
          'Rejoignez d’autres commerçants pour acheter en\n'
          'groupe et profiter de meilleurs prix.',
    ),
    _SlideData(
      image: 'assets/image/onb2.png',
      title: 'Payez en toute confiance !',
      text:
          'Vos paiements sont sécurisés et 100% traçables.\n'
          'Profitez d’une transparence totale à chaque\n'
          'transaction.',
    ),
    _SlideData(
      image: 'assets/image/onb3.png',
      title: 'Le monde à portée de main !',
      text:
          'Accédez directement aux meilleurs fournisseurs.\n'
          'Découvrez et commandez des produits du\n'
          'monde entier.',
    ),
  ];

  void _skip() {
    //Va directement après l’onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
    );
  }

  void _next() {
    if (_current < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      _skip(); // sur la dernière page: “Commencer”
    }
  }

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

              // --- PageView des 3 slides ---
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (context, index) {
                    final s = _slides[index];
                    return _Slide(
                      data: s,
                      isShort: isShort,
                      titleColor: _title,
                      textColor: _sub,
                    );
                  },
                ),
              ),

              // --- Indicateurs (points) ---
              Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _current;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      width: active ? 22 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: active ? _blue : _beige,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),
              ),

              // --- Bas : Passer + bouton circulaire ---
              Row(
                children: [
                  TextButton(
                    onPressed: _skip,
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
                  // Debug-only shortcut to accueil
                  if (kDebugMode)
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/accueil'),
                      child: const Text('Ouvrir l\'accueil (dev)', style: TextStyle(color: Colors.redAccent)),
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
                      icon: Icon(
                        _current < _slides.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                        color: Colors.white,
                      ),
                      onPressed: _next,
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

// ------------------ Petites classes utilitaires ------------------

class _SlideData {
  final String image;
  final String title;
  final String text;
  const _SlideData({
    required this.image,
    required this.title,
    required this.text,
  });
}

class _Slide extends StatelessWidget {
  final _SlideData data;
  final bool isShort;
  final Color titleColor;
  final Color textColor;

  const _Slide({
    //super.key,
    required this.data,
    required this.isShort,
    required this.titleColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Illustration
        Center(
          child: Image.asset(
            data.image,
            height: isShort ? size.height * 0.33 : size.height * 0.40,
            fit: BoxFit.contain,
          ),
        ),

        SizedBox(height: isShort ? 18 : 28),

        // Titre
        Text(
          data.title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 25,
            height: 1.20,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),

        const SizedBox(height: 16),

        // Paragraphe
        Text(
          data.text,
          style: TextStyle(fontSize: 13, height: 1.50, color: textColor),
        ),
      ],
    );
  }
}
