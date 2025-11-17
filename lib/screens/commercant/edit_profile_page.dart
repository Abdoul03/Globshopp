import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/services/commercantService.dart';

class EditProfilePage extends StatefulWidget {
  final Commercant? commercant;
  const EditProfilePage({super.key, this.commercant});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _service = CommercantService();
  late final TextEditingController prenomCtrl;
  late final TextEditingController nomCtrl;
  late final TextEditingController telephoneCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController passwordCtrl;
  late final TextEditingController usernameCtrl;
  bool showPassword = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    prenomCtrl = TextEditingController(text: widget.commercant?.prenom ?? '');
    nomCtrl = TextEditingController(text: widget.commercant?.nom ?? '');
    telephoneCtrl = TextEditingController(
      text: widget.commercant?.telephone ?? '',
    );
    emailCtrl = TextEditingController(text: widget.commercant?.email ?? '');
    usernameCtrl = TextEditingController(
      text: widget.commercant?.username ?? '',
    );
    passwordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    prenomCtrl.dispose();
    nomCtrl.dispose();
    telephoneCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Constant.colorsBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Modifier le profile',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nom'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nomCtrl,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre nom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3D74B6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Prenom'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: prenomCtrl,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre prenom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3D74B6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Prénom requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Nom d’utilisateur'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: usernameCtrl,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre nom d’utilisateur',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3D74B6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nom d’utilisateur requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Telephone'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: telephoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre numero de téléphone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3D74B6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Téléphone requis'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre adresse email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3D74B6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Email requis';
                        final ok = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(v);
                        return ok ? null : 'Email invalide';
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Mot de passe'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: 'Entrez votre mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6E6E6),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3D74B6),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => showPassword = !showPassword);
                          },
                        ),
                      ),
                      // Mot de passe optionnel: pas de validator requis
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Constant.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            final id = widget.commercant?.id;
                            if (id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ID utilisateur introuvable'),
                                ),
                              );
                              return;
                            }
                            setState(() => isSubmitting = true);
                            try {
                              final payload = {
                                'nom': nomCtrl.text.trim(),
                                'prenom': prenomCtrl.text.trim(),
                                'username': usernameCtrl.text.trim(),
                                'telephone': telephoneCtrl.text.trim(),
                                'email': emailCtrl.text.trim(),
                                'actif': widget.commercant?.actif ?? true,
                                'role': 'ROLE_COMMERCANT',
                                'idPays': widget.commercant?.pays?.id ?? 1,
                              };
                              if (passwordCtrl.text.trim().isNotEmpty) {
                                payload['motDePasse'] = passwordCtrl.text;
                              }
                              final updated = await _service.updateCommercant(
                                id,
                                payload,
                              );

                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profil modifié avec succès'),
                                ),
                              );
                              Navigator.pop(context, updated);
                            } catch (e) {
                              if (!mounted) return;
                              final msg = e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            } finally {
                              if (mounted) setState(() => isSubmitting = false);
                            }
                          },
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Modifier',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
