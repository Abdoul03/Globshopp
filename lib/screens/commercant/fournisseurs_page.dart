// lib/screens/fournisseurs_page.dart
import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:globshopp/screens/custom/custumSearchBar.dart';
import 'package:globshopp/services/fournisseurService.dart';
import 'supplier_detail_page.dart';

class FournisseursPage extends StatefulWidget {
  const FournisseursPage({super.key});

  @override
  State<FournisseursPage> createState() => _FournisseursPageState();
}

class _FournisseursPageState extends State<FournisseursPage> {
  final _searchCtrl = TextEditingController();
  final FournisseurService _fournisseurService = FournisseurService();
  List<Fournisseur> _fournisseur = [];
  List<Fournisseur> _searchResultats = [];
  bool isLoading = false;

  @override
  void initState() {
    chargerFournisseur();
    super.initState();
  }

  Future<void> chargerFournisseur() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fournisseurs = await _fournisseurService.getAllFournisseur();
      setState(() {
        _fournisseur = fournisseurs;
        _searchResultats = fournisseurs;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        setState(() {
          _searchResultats = _fournisseur;
        });
        return;
      }

      setState(() {
        _searchResultats = _fournisseur.where((fournisseur) {
          final titreMatch = fournisseur.nom.toLowerCase().contains(
            text.toLowerCase(),
          );
          final descMatch = fournisseur.prenom.toLowerCase().contains(
            text.toLowerCase(),
          );
          return titreMatch || descMatch;
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Constant.blue,
              backgroundColor: Constant.colorsWhite,
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,

            // ------------ CONTENU ------------
            body: CustomScrollView(
              slivers: [
                // Bandeau bleu fixe avec champ de recherche
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Constant.blue,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 0, // on n'affiche que la partie "bottom"
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(88),
                    child: Container(
                      color: Constant.blue,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 52),
                        // child: _SearchField(controller: _searchCtrl),
                        child: Custumsearchbar(
                          hintText: "Rechercher",
                          onchange: _onSearchTextChanged,
                          controller: _searchCtrl,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // Liste des fournisseurs
                SliverList.separated(
                  itemCount: _searchCtrl.text.trim().isNotEmpty
                      ? _searchResultats.length
                      : _fournisseur.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final currentList = _searchCtrl.text.trim().isNotEmpty
                        ? _searchResultats
                        : _fournisseur;

                    final supplier = currentList[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SupplierCard(
                        supplier: supplier,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SupplierDetailPage(supplier: supplier),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
  }
}

class SupplierCard extends StatelessWidget {
  const SupplierCard({super.key, required this.supplier, this.onTap});
  final Fournisseur supplier;
  final VoidCallback? onTap;

  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE6E6EA);

  @override
  Widget build(BuildContext context) {
    final String firstNameInitial = supplier.prenom.isNotEmpty
        ? supplier.prenom[0].toUpperCase()
        : '';
    final String lastNameInitial = supplier.nom.isNotEmpty
        ? supplier.nom[0].toUpperCase()
        : '';
    final String initials = firstNameInitial + lastNameInitial;
    final imageWidget = supplier.photoUrl == null
        ? Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Constant.blue, // ou une autre couleur par défaut
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Image.network(
            supplier.photoUrl!,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackImage(),
          );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap, // ✅ clique → navigation
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: _cardBorder),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image (avec Hero pour une transition fluide)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Hero(
                  tag: 'supplier:${supplier.photoUrl}_${supplier.nom}',
                  child: imageWidget,
                ),
              ),
              const SizedBox(width: 12),

              // Textes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom
                    Text(
                      "${supplier.prenom} ${supplier.nom}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Sous-titre
                    Text(
                      supplier.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _sub,
                        fontSize: 13.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Ligne: "Vérifier" à gauche — Ville/Pays à droite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   supplier.verified ? 'Vérifier' : 'Non vérifié',
                        //   style: TextStyle(
                        //     color: supplier.verified
                        //         ? const Color(0xFF2F80ED)
                        //         : Colors.grey,
                        //     fontSize: 13.5,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                        Text(
                          "${supplier.pays != null ? supplier.pays?.nom : "Bamako/Mali"}",
                          style: const TextStyle(color: _sub, fontSize: 13.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackImage() => Container(
    width: 64,
    height: 64,
    color: const Color(0xFFF0F1F5),
    child: const Icon(Icons.image_outlined),
  );
}

/// Icône image (mêmes assets que tes autres écrans)
