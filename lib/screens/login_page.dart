// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'Inscription.dart';     // ou 'inscription.dart' selon la casse
import 'mdpoublier1.dart';    // ForgotPasswordPage
import 'accueil.dart';        // ⬅️ HomePage (page d'accueil)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 🎨 Palette
  static const _blue   = Color(0xFF2F80ED);
  static const _text   = Color(0xFF0B0B0B);
  static const _hint   = Color(0xFF9CA3AF);
  static const _border = Color(0xFFE6E6E6);
  static const _light  = Color(0xFFEFF4FF);

  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: _hint),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _border, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _blue, width: 1.4),
    ),
  );

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _goHome() {
    // 👉 Après vérification/connexion réussie, on navigue vers l'accueil
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false, // supprime tout l'historique pour empêcher le retour au login
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShort = size.height < 720;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // pas de flèche retour
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Connexion',
          style: TextStyle(color: _text, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isShort ? 12 : 20),

                const Text('Email', style: TextStyle(fontSize: 14, color: _text)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez votre adresse email'),
                ),

                const SizedBox(height: 16),

                const Text('Mot de passe', style: TextStyle(fontSize: 14, color: _text)),
                const SizedBox(height: 8),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  decoration: _decoration('Entrez votre mot de passe').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _goHome(), // Entrée => tente la connexion puis va à l'accueil
                ),

                const SizedBox(height: 10),

                // "Mot de passe oublié ?" centré + navigation
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                      );
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Mot de passe oublié ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.5, color: Colors.black54),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Bouton Connexion -> Accueil
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _goHome, // ⬅️ redirige vers HomePage (accueil.dart)
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Se connecter'),
                  ),
                ),

                const SizedBox(height: 24),

                // Séparateur "Ou"
                Row(
                  children: const [
                    Expanded(child: Divider(color: _border, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Ou', style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Divider(color: _border, thickness: 1)),
                  ],
                ),

                const SizedBox(height: 20),

                _SocialButton(
                  label: 'Connectez-vous avec Google',
                  assetPath: 'assets/icons/google.png',
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                _SocialButton(
                  label: 'Connectez-vous avec Facebook',
                  assetPath: 'assets/icons/facebook.png',
                  onTap: () {},
                ),

                const SizedBox(height: 28),

                // Vers Inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Vous n’avez pas de compte ? ', style: TextStyle(color: Colors.black87)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Inscrivez-vous',
                        style: TextStyle(color: _blue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isShort ? 24 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String assetPath;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.assetPath,
    required this.onTap,
  });

  static const _light = Color(0xFFEFF4FF);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: _light,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
              alignment: Alignment.center,
              child: Image.asset(
                assetPath,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported_outlined, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
