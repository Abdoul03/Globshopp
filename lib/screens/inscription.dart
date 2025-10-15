// lib/screens/inscription.dart
import 'package:flutter/material.dart';
import 'package:globshopp/screens/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // 🎨 Palette
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _hint = Color(0xFF9CA3AF);
  static const _border = Color(0xFFE6E6E6);

  // 🔹 Contrôleurs
  final _nameCtrl = TextEditingController();
  final _firstCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController(); // nouveau: confirmation

  bool _obscure = true;
  bool _obscureConfirm = true; // œil pour le champ de confirmation

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

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _firstCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // 🔹 Titre
                const Center(
                  child: Text(
                    'Inscription',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _text,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // 🔸 Nom
                TextField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez votre nom'),
                ),
                const SizedBox(height: 16),

                // 🔸 Prénom
                TextField(
                  controller: _firstCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez votre prénom'),
                ),
                const SizedBox(height: 16),

                // 🔸 Téléphone
                TextField(
                  controller: _phoneCtrl,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration('Entrez votre numéro de téléphone'),
                ),
                const SizedBox(height: 16),

                // 🔸 Email
                TextField(
                  controller: _emailCtrl,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration('Entrez votre adresse email'),
                ),
                const SizedBox(height: 16),

                // 🔸 Mot de passe
                TextField(
                  controller: _passCtrl,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscure,
                  decoration: _decoration('Entrez votre mot de passe').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ 🔸 Confirmer le mot de passe
                TextField(
                  controller: _confirmCtrl,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureConfirm,
                  decoration: _decoration('Confirmez votre mot de passe')
                      .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black54,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                ),

                const SizedBox(height: 28),

                // 🔵 Bouton S’inscrire
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nameCtrl.text.trim();
                      final first = _firstCtrl.text.trim();
                      final phone = _phoneCtrl.text.trim();
                      final email = _emailCtrl.text.trim();
                      final pass = _passCtrl.text.trim();
                      final confirm = _confirmCtrl.text.trim();

                      // Petites validations côté UI
                      if ([
                        name,
                        first,
                        phone,
                        email,
                        pass,
                        confirm,
                      ].any((e) => e.isEmpty)) {
                        _showSnack('Veuillez remplir tous les champs.');
                        return;
                      }
                      if (pass.length < 6) {
                        _showSnack(
                          'Le mot de passe doit contenir au moins 6 caractères.',
                        );
                        return;
                      }
                      if (pass != confirm) {
                        _showSnack('Les mots de passe ne correspondent pas.');
                        return;
                      }

                      // TODO: logique d’inscription (appel API, etc.)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                      _showSnack('Formulaire valide ');
                    },
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
                    child: const Text("S'inscrire"),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Séparateur "Ou"
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

                // 🔸 Boutons sociaux
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _SocialSquare(
                      path: 'assets/icons/google.png',
                      tooltip: 'Se connecter avec Google',
                    ),
                    _SocialSquare(
                      path: 'assets/icons/facebook.png',
                      tooltip: 'Se connecter avec Facebook',
                    ),
                  ],
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialSquare extends StatelessWidget {
  final String path;
  final String tooltip;
  const _SocialSquare({required this.path, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // TODO: action OAuth
        },
        child: Container(
          width: 72,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4FF), // léger fond bleuté/gris
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            path,
            width: 28,
            height: 28,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported_outlined),
          ),
        ),
      ),
    );
  }
}
