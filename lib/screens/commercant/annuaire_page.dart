// lib/screens/annuaire_page.dart
import 'package:flutter/material.dart';

class AnnuairePage extends StatefulWidget {
  const AnnuairePage({super.key});

  @override
  State<AnnuairePage> createState() => _AnnuairePageState();
}

class _AnnuairePageState extends State<AnnuairePage> {
  // Couleurs
  // couleurs locales supprimées (utiliser `Constant` si besoin)

  final _searchCtrl = TextEditingController();
  String _q = ''; // terme de recherche

  final _companies = <Company>[
    Company(
      name: 'Global Logistics inc',
      description: 'Spécialisé dans le fret aérien et maritime international.',
      phone: '+223 85 47 47 57',
      logo: 'assets/image/e1.png',
    ),
    Company(
      name: 'Swift Cargo Solutions',
      description:
          'Votre partenaire fiable pour un transport de marchandises sans faille.',
      phone: '+223 85 47 47 57',
      logo: 'assets/image/e2.png',
    ),
    Company(
      name: 'Sekou Keïta',
      description: 'Un transport de fret efficace et rentable',
      phone: '+223 85 47 47 57',
      logo: 'assets/image/e3.png',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrage sur nom / description / téléphone
    final filtered = _companies.where((c) {
      if (_q.isEmpty) return true;
      final q = _q.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.phone.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --------- En-tête + Recherche ---------
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 90,
            title: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _SearchField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _q = v.trim()),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // --------- Liste des entreprises (filtrée) ---------
          SliverList.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CompanyCard(company: filtered[i]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

/* =================== Widgets =================== */

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Rechercher une entreprise...',
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/icons/search.png',
              width: 20,
              height: 20,
              color: Colors.grey[700],
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.search_rounded, size: 20),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class Company {
  final String name;
  final String description;
  final String phone;
  final String logo;

  Company({
    required this.name,
    required this.description,
    required this.phone,
    required this.logo,
  });
}

class CompanyCard extends StatelessWidget {
  final Company company;
  const CompanyCard({super.key, required this.company});

  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              company.logo,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported_outlined, size: 40),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: _sub),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/phone.png',
                      width: 16,
                      height: 16,
                      color: Colors.grey[700],
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.phone, size: 16),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        company.phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: _text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
