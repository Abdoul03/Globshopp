// lib/screens/role_selection_page.dart
import 'package:flutter/material.dart';
import 'package:globshopp/screens/Inscription.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

enum _UserRole { merchant, supplier }

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  _UserRole? _selected;

  // Palette
  static const _blue = Color(0xFF2F80ED);
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _border = Color(0xFFE6E6E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      'Qui êtes-vous ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sélectionnez votre profil pour\ncontinuer sur GlobalShopper',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: _sub,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Commerçant
                    _RoleCard(
                      selected: _selected == _UserRole.merchant,
                      leading: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selected == _UserRole.merchant
                                ? _blue
                                : _border,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/icons/Vector.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: 'Commerçant',
                      subtitle:
                          'Achetez des produits et mutualisez vos commandes avec d’autres commerçants.',
                      onTap: () =>
                          setState(() => _selected = _UserRole.merchant),
                    ),
                    const SizedBox(height: 18),

                    // Fournisseur
                    _RoleCard(
                      selected: _selected == _UserRole.supplier,
                      leading: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selected == _UserRole.supplier
                                ? Colors.orangeAccent
                                : _border,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/icons/Vector (1).png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: 'Fournisseur',
                      subtitle:
                          'Vendez vos produits à un réseau de commerçants et développez votre marché.',
                      onTap: () =>
                          setState(() => _selected = _UserRole.supplier),
                    ),

                    const SizedBox(height: 32),

                    // 🔵 Bouton Continuer -> LoginPage
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selected == null
                            ? null
                            : () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const LoginPage(),
                                //   ),
                                // );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpPage(),
                                  ),
                                );
                                // Navigator.pushNamed(context, '/login'); // si routes nommées
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _blue,
                          disabledBackgroundColor: _blue.withOpacity(0.35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continuer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool selected;
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.selected,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const _blue = Color(0xFF2F80ED);
  static const _border = Color(0xFFE6E6E6);
  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _blue.withOpacity(0.06) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? _blue : _border, width: 1.2),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: _blue.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: _sub,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: _blue, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
