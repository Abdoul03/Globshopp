// lib/screens/login_form.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/tokenPair.dart';
import 'package:globshopp/screens/commercant/commercantNavigation.dart';
import 'package:globshopp/screens/fournisseur/navigationBar.dart';
import 'package:globshopp/screens/role_selection_page.dart';
import 'package:globshopp/services/authentification.dart';
import 'commercant/accueil.dart';
import 'mdpoublier1.dart';
import '../widgets/login/email_field.dart';
import '../widgets/login/password_field.dart';
import '../widgets/login/primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _border = Color(0xFFE6E6E6);

  final Authentification _authentification = Authentification();
  bool isLoading = false;

  final TextEditingController identifiant = TextEditingController();
  final TextEditingController motDePasse = TextEditingController();

  @override
  void dispose() {
    identifiant.dispose();
    motDePasse.dispose();
    super.dispose();
  }

  String? extractRoleFromToken(String accessToken) {
    try {
      // Le token a la forme header.payload.signature
      final parts = accessToken.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      // Base64Url decoding
      var normalized = base64Url.normalize(payload);
      final payloadMap = jsonDecode(utf8.decode(base64Url.decode(normalized)));

      if (payloadMap is! Map<String, dynamic>) return null;
      return payloadMap['role']
          as String?; // Assumes backend put the role claim as 'role'
    } catch (e) {
      return null;
    }
  }

  Future<TokenPair> connexion() async {
    setState(() {
      isLoading = true;
    });

    try {
      final tokenPair = await _authentification.connexion(
        identifiant.text.trim(),
        motDePasse.text.trim(),
      );
      setState(() {
        isLoading = false;
      });
      final role = extractRoleFromToken(tokenPair.accessToken);
      if (role == 'ROLE_COMMERCANT') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Bienvenue")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Commercantnavigation()),
        );
      } else if (role == 'ROLE_FOURNISSEUR') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Bienvenue")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Navigationbar()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Rôle inconnu")));
      }
      print(tokenPair.accessToken);
      print(tokenPair.refreshToken);
      return tokenPair;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShort = size.height < 720;

    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height - 24),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isShort ? 12 : 20),

                const Text(
                  'Identifiant',
                  style: TextStyle(fontSize: 14, color: _text),
                ),
                const SizedBox(height: 8),
                EmailField(controller: identifiant),

                const SizedBox(height: 16),

                const Text(
                  'Mot de passe',
                  style: TextStyle(fontSize: 14, color: _text),
                ),
                const SizedBox(height: 8),
                PasswordField(
                  controller: motDePasse,
                  // onSubmitted: (_) => _attemptLogin(),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
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

                PrimaryButton(
                  onPressed: connexion,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Se connecter'),
                ),

                const SizedBox(height: 24),

                Row(
                  children: const [
                    Expanded(child: Divider(color: _border, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Ou',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(child: Divider(color: _border, thickness: 1)),
                  ],
                ),

                const SizedBox(height: 20),

                SocialButton(
                  label: 'Connectez-vous avec Google',
                  assetPath: 'assets/icons/google.png',
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                SocialButton(
                  label: 'Connectez-vous avec Facebook',
                  assetPath: 'assets/icons/facebook.png',
                  onTap: () {},
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Vous n’avez pas de compte ? ',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoleSelectionPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Inscrivez-vous',
                        style: TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w600,
                        ),
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

class SocialButton extends StatelessWidget {
  final String label;
  final String assetPath;
  final VoidCallback onTap;

  const SocialButton({
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
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
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
