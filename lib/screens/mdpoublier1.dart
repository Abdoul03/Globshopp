// lib/screens/mdpoublier1.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'verification.dart'; // ✅ page de destination

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // 🎨 Palette
  static const _blue   = Color(0xFF2F80ED);
  static const _text   = Color(0xFF0B0B0B);
  static const _hint   = Color(0xFF9CA3AF);
  static const _border = Color(0xFFE6E6E6);

  final _emailCtrl = TextEditingController();

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

  void _sendCode() {
    final email = _emailCtrl.text.trim();

    // petite validation
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un email valide.')),
      );
      return;
    }

    // (Optionnel) TODO: appel API d’envoi du code ici

    // 👉 navigation vers la page de vérification + passage de l'email
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationPage(email: email),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar (flèche retour)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // 👉 Centrage vertical + scroll si écran petit
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // centrage vertical
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // 🧭 Titre centré et un peu plus grand
                  const Center(
                    child: Text(
                      'Mot de passe oublier ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _text,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🖼 Illustration
                  Center(
                    child: Image.asset(
                      'assets/image/mdpo.png', // adapte le chemin si besoin
                      height: 240,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 📨 Email
                  const Text('Email', style: TextStyle(fontSize: 14, color: _text)),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: _decoration('Entrez votre email'),
                    onSubmitted: (_) => _sendCode(),
                  ),

                  const SizedBox(height: 24),

                  // 🔵 Envoyer le code → VerificationPage
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _sendCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Envoyer le code'),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 🔗 Lien retour à la connexion
                  Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Retour à la page de ', style: TextStyle(color: Colors.black87)),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            'connexion',
                            style: TextStyle(color: _blue, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Text(' ?', style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
