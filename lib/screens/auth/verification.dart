// lib/screens/verification.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';
import 'changer_mdp.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key, this.email = 'samabdoul03@gmail.com'});

  final String email;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  // 🎨 Palette
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _border = Color(0xFFE6E6E6);

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();
  final _f4 = FocusNode();

  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();

  @override
  void dispose() {
    _f1.dispose();
    _f2.dispose();
    _f3.dispose();
    _f4.dispose();
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    super.dispose();
  }

  void _onChanged({
    required String value,
    required FocusNode current,
    FocusNode? next,
    FocusNode? prev,
  }) {
    if (value.length == 1 && next != null) {
      next.requestFocus();
    } else if (value.isEmpty && prev != null) {
      prev.requestFocus();
    }
  }

  String get _code => _c1.text + _c2.text + _c3.text + _c4.text;

  void _verify() {
    if (_code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez le code complet (4 chiffres).')),
      );
      return;
    }

    // (Optionnel) TODO: vérifier le code côté serveur

    // 👉 Navigation vers la page "changer_mdp.dart"
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
    );
  }

  void _resend() {
    // TODO: renvoi du code
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code renvoyé 📩')));
  }

  InputDecoration _otpDecoration() => InputDecoration(
    counterText: '',
    contentPadding: const EdgeInsets.symmetric(vertical: 18),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _blue, width: 1.6),
    ),
  );

  Widget _otpBox({
    required TextEditingController ctrl,
    required FocusNode node,
    FocusNode? next,
    FocusNode? prev,
  }) {
    return SizedBox(
      width: 62,
      child: TextField(
        controller: ctrl,
        focusNode: node,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: _otpDecoration(),
        onChanged: (v) =>
            _onChanged(value: v, current: node, next: next, prev: prev),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShort = size.height < 720;
    final double topGap = isShort ? 48.0 : 80.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height - (isShort ? 120 : 160),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: topGap),

              const Text(
                'Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Entre le code pour continuer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: _sub),
              ),

              const SizedBox(height: 36),

              Text(
                'Nous avons envoyer un code à\n${widget.email}',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, height: 1.5, color: _text),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _otpBox(ctrl: _c1, node: _f1, next: _f2),
                  _otpBox(ctrl: _c2, node: _f2, next: _f3, prev: _f1),
                  _otpBox(ctrl: _c3, node: _f3, next: _f4, prev: _f2),
                  _otpBox(ctrl: _c4, node: _f4, prev: _f3),
                ],
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _verify, // ✅ va pousser vers ResetPasswordPage
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
                  child: const Text('Verifier'),
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Vous n’avez pas reçu le code ? ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    InkWell(
                      onTap: _resend,
                      child: const Text(
                        'Renvoyer',
                        style: TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Retour a la page de ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'connexion',
                        style: TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Text(' ?', style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),

              SizedBox(height: isShort ? 20 : 32),
            ],
          ),
        ),
      ),
    );
  }
}
