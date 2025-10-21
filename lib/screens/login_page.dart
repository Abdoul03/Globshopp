// lib/screens/login_page.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const _text = Color(0xFF0B0B0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Connexion',
          style: TextStyle(
            color: _text,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/accueil'),
                  child: const Text("Ouvrir l'accueil (dev)", style: TextStyle(color: Colors.redAccent)),
                ),
              ),
            const Expanded(child: LoginForm()),
          ],
        ),
      ),
    );
  }
}
