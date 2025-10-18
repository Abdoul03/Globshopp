// lib/screens/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Palette
  static const _blue     = Color(0xFF2F80ED);
  static const _text     = Color(0xFF0B0B0B);
  static const _sub      = Color(0xFF7C7E85);
  static const _tileBg   = Color(0xFFF3F4F6);
  static const _dangerBg = Color(0xFFFFE2E0);
  static const _danger   = Color(0xFFE94A45);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          // ====== SLIVER APP BAR avec icône modifier ======
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 64, // 🔹 plus compact
            title: const Text(
              'Profil',
              style: TextStyle(
                color: _text,
                fontSize: 18, // 🔹 taille réduite
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _CircleImageButton(
                  imagePath: 'assets/icons/edit.png',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Modifier le profil')),
                    );
                  },
                ),
              ),
            ],
          ),

          // ====== CONTENU ======
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  const SizedBox(height: 4),
                  Center(
                    child: CircleAvatar(
                      radius: 42, // 🔹 légèrement plus petit
                      backgroundColor: const Color(0xFFE8EEF9),
                      child: ClipOval(
                        child: Image.network(
                          'https://i.imgur.com/9DKYzjK.jpeg',
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 48,
                            color: _blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Champs info
                  const _FieldLabel('Nom'),
                  const _InfoTile(
                    icon: Icons.person_outline_rounded,
                    text: 'Abdoul Ibrahima Samaké',
                  ),
                  const SizedBox(height: 12),

                  const _FieldLabel('Téléphone'),
                  const _InfoTile(
                    icon: Icons.phone_outlined,
                    text: '71267813',
                  ),
                  const SizedBox(height: 12),

                  const _FieldLabel('Email'),
                  const _InfoTile(
                    icon: Icons.mail_outline_rounded,
                    text: 'Samabdoul03@gmail.com',
                  ),
                  const SizedBox(height: 12),

                  const _FieldLabel('Rôle'),
                  const _InfoTile(
                    icon: Icons.vpn_key_outlined,
                    text: 'Commerçant',
                  ),
                  const SizedBox(height: 12),

                  const _FieldLabel('Adresse'),
                  const _InfoTile(
                    icon: Icons.location_city_outlined,
                    text: 'Bamako / Mali / Grand marché',
                  ),

                  const SizedBox(height: 24),

                  // Bouton Déconnexion
                  SizedBox(
                    width: double.infinity,
                    height: 46, // 🔹 plus fin
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _dangerBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                              (route) => false,
                        );
                      },
                      child: const Text(
                        'Déconnexion',
                        style: TextStyle(
                          color: _danger,
                          fontSize: 14.5, // 🔹 réduit
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ====== NAVIGATION BAR ======
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          height: 76, // 🔹 légèrement plus bas
          indicatorColor: Color(0x142F80ED),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          selectedIndex: 4,
          onDestinationSelected: (i) {
            if (i == 0) Navigator.pushReplacementNamed(context, '/accueil');
            if (i == 1) Navigator.pushReplacementNamed(context, '/fournisseurs');
            if (i == 2) Navigator.pushReplacementNamed(context, '/commandes');
            if (i == 3) Navigator.pushReplacementNamed(context, '/annuaire');
          },
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          destinations: const [
            NavigationDestination(
              icon: _NavIcon('assets/icons/home.png', size: 26),
              selectedIcon: _NavIcon('assets/icons/home_active.png', size: 26),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/store.png', size: 26),
              selectedIcon: _NavIcon('assets/icons/store_active.png', size: 26),
              label: 'Fournisseurs',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/orders.png', size: 26),
              selectedIcon: _NavIcon('assets/icons/orders_active.png', size: 26),
              label: 'Commandes',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/contacts.png', size: 26),
              selectedIcon: _NavIcon('assets/icons/contacts_active.png', size: 26),
              label: 'Annuaire',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/profile.png', size: 26),
              selectedIcon: _NavIcon('assets/icons/profile_active.png', size: 26),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- WIDGETS ---------- */

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: ProfilePage._sub,
          fontSize: 12, // 🔹 réduit
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46, // 🔹 plus compact
      decoration: BoxDecoration(
        color: ProfilePage._tileBg,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: ProfilePage._blue, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ProfilePage._text,
                fontSize: 13, // 🔹 réduit
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icône image pour NavigationBar
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 24, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}

/// Bouton image rond pour la SliverAppBar
class _CircleImageButton extends StatelessWidget {
  const _CircleImageButton({required this.imagePath, this.onTap, super.key});
  final String imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: 36, // 🔹 plus petit
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 3,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.edit, size: 18, color: ProfilePage._blue),
          ),
        ),
      ),
    );
  }
}
