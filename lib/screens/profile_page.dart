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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne d'actions (seulement le bouton d'édition à droite)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  splashRadius: 22,
                  icon: const Icon(Icons.edit, color: _blue, size: 22),
                ),
              ),

              // Avatar centré
              const SizedBox(height: 6),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFFE8EEF9),
                  child: ClipOval(
                    child: Image.network(
                      'https://i.imgur.com/9DKYzjK.jpeg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 56,
                        color: _blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Nom
              const _FieldLabel('Nom'),
              const _InfoTile(
                icon: Icons.person_outline_rounded,
                text: 'Abdoul Ibrahima Samaké',
              ),
              const SizedBox(height: 16),

              // Téléphone
              const _FieldLabel('Téléphone'),
              const _InfoTile(
                icon: Icons.phone_outlined,
                text: '71267813',
              ),
              const SizedBox(height: 16),

              // Email
              const _FieldLabel('Email'),
              const _InfoTile(
                icon: Icons.mail_outline_rounded,
                text: 'Samabdoul03@gmail.com',
              ),
              const SizedBox(height: 16),

              // Rôle
              const _FieldLabel('Rôle'),
              const _InfoTile(
                icon: Icons.vpn_key_outlined,
                text: 'Commerçant',
              ),
              const SizedBox(height: 16),

              // Adresse
              const _FieldLabel('Adresse'),
              const _InfoTile(
                icon: Icons.location_city_outlined,
                text: 'Bamako/Mali/ Grand marché',
              ),

              const SizedBox(height: 28),

              // Bouton Déconnexion
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _dangerBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Déconnexion → retourne à l’écran de login et nettoie la pile
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ====== NAVIGATION BAR BOTTOM (pattern unifié) ======
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          height: 84,
          indicatorColor: Color(0x142F80ED),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        child: NavigationBar(
          // ← Profil = index 4
          selectedIndex: 4,
          onDestinationSelected: (i) {
            if (i == 0) {
              Navigator.pushReplacementNamed(context, '/accueil');
              return;
            }
            if (i == 1) {
              Navigator.pushReplacementNamed(context, '/fournisseurs');
              return;
            }
            if (i == 2) {
              Navigator.pushReplacementNamed(context, '/commandes');
              return;
            }
            if (i == 3) {
              Navigator.pushReplacementNamed(context, '/annuaire');
              return;
            }
            if (i == 4) {
              // déjà sur Profil
              return;
            }
          },
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          destinations: const [
            NavigationDestination(
              icon: _NavIcon('assets/icons/home.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/home_active.png', size: 28),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/store.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/store_active.png', size: 28),
              label: 'Fournisseurs',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/orders.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/orders_active.png', size: 28),
              label: 'Commandes',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/contacts.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/contacts_active.png', size: 28),
              label: 'Annuaire',
            ),
            NavigationDestination(
              icon: _NavIcon('assets/icons/profile.png', size: 28),
              selectedIcon: _NavIcon('assets/icons/profile_active.png', size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

/* --------- Petits widgets réutilisables --------- */

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: ProfilePage._sub,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: ProfilePage._tileBg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: ProfilePage._blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ProfilePage._text,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icône image pour NavigationBar (const-friendly)
class _NavIcon extends StatelessWidget {
  final String path;
  final double size;
  const _NavIcon(this.path, {this.size = 26, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}
