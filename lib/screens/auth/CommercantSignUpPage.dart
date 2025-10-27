import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/screens/auth/login_page.dart';
import 'package:globshopp/services/Inscription.dart';

class Commercantsignuppage extends StatefulWidget {
  const Commercantsignuppage({super.key});

  @override
  State<Commercantsignuppage> createState() => _CommercantsignuppageState();
}

class _CommercantsignuppageState extends State<Commercantsignuppage> {
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _motDePasse = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  final Inscription _inscription = Inscription();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool isLoading = false;

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Constant.colorsgray),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Constant.border, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Constant.blue, width: 1.4),
    ),
  );

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> inscriptionCommercant(Commercant commercant) async {
    setState(() {
      isLoading = true;
    });
    try {
      final resultat = await _inscription.registerCommercant(commercant);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultat ?? "Inscription réussie")),
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    } catch (e) {
      setState(() => isLoading = false);
      print("On a une erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur serveur, veuillez réessayer.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nom.dispose();
    _prenom.dispose();
    _userName.dispose();
    _email.dispose();
    _telephone.dispose();
    _motDePasse.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Titre
                const Center(
                  child: Text(
                    'Inscription',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Constant.colorsBlack,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                //Nom
                TextField(
                  controller: _nom,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez votre nom'),
                ),
                const SizedBox(height: 16),

                //Prénom
                TextField(
                  controller: _prenom,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez votre prénom'),
                ),
                const SizedBox(height: 16),

                // UserName
                TextField(
                  controller: _userName,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration('Entrez votre username'),
                ),
                const SizedBox(height: 16),

                // telephone
                TextField(
                  controller: _telephone,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration('Entrez votre numéro de téléphone'),
                ),
                const SizedBox(height: 16),

                //Email
                TextField(
                  controller: _email,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration('Entrez votre adresse email'),
                ),
                const SizedBox(height: 16),

                // Mot de passe
                TextField(
                  controller: _motDePasse,
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

                //Confirmer le mot de passe
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

                //Bouton S’inscrire
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = _nom.text.trim();
                      final first = _prenom.text.trim();
                      final userName = _userName.text.trim();
                      final email = _email.text.trim();
                      final tel = _telephone.text.trim();
                      final pass = _motDePasse.text.trim();
                      final confirm = _confirmCtrl.text.trim();

                      // Petites validations côté UI
                      if ([
                        name,
                        first,
                        userName,
                        email,
                        tel,
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

                      final user = Commercant(
                        nom: name,
                        prenom: first,
                        username: userName,
                        email: email,
                        telephone: tel,
                        motDePasse: pass,
                      );
                      inscriptionCommercant(user);

                      _nom.clear();
                      _prenom.clear();
                      _userName.clear();
                      _telephone.clear();
                      _email.clear();
                      _motDePasse.clear();
                      _confirmCtrl.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.blue,
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
                    child: isLoading
                        ? CircularProgressIndicator(color: Constant.colorsWhite)
                        : const Text("S'inscrire"),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Séparateur "Ou"
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: Constant.border, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Ou',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Constant.border, thickness: 1),
                    ),
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
