import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/commercant/custom/product_detail_page.dart';
import 'package:globshopp/services/produitService.dart';

class SupplierDetailPage extends StatefulWidget {
  final Fournisseur supplier;
  const SupplierDetailPage({super.key, required this.supplier});

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  final Produitservice _produitservice = Produitservice();

  List<Produit> _produits = [];
  bool isLoading = false;

  Future<void> getAllproduit() async {
    try {
      setState(() {
        isLoading = true;
      });
      final produits = await _produitservice.getFournisseurProduitsById(
        widget.supplier.id!,
      );
      setState(() {
        _produits = produits;
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

  @override
  void initState() {
    getAllproduit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Détail fournisseur',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Image d’en-tête avec Hero (même tag que la carte)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            // child: Hero(
            //   tag: 'supplier:${supplier.photoUrl}_${supplier.nom}',
            //   child: _imageWidget(supplier),
            // ),
          ),
          const SizedBox(height: 16),

          // Infos fournisseur
          Text(
            "${widget.supplier.prenom} ${widget.supplier.nom}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            widget.supplier.telephone,
            style: const TextStyle(fontSize: 14, color: Color(0xFF5C5F66)),
          ),
          const SizedBox(height: 4),
          Text(
            "${widget.supplier.pays != null ? widget.supplier.pays?.nom : "Bamako/Mali"}",
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF5C5F66)),
          ),
          const SizedBox(height: 10),

          // Row(
          //   children: [
          //     Icon(
          //       supplier.verified
          //           ? Icons.verified_rounded
          //           : Icons.verified_outlined,
          //       color: supplier.verified
          //           ? const Color(0xFF2F80ED)
          //           : Colors.grey,
          //       size: 18,
          //     ),
          //     const SizedBox(width: 6),
          //     Text(
          //       supplier.verified ? 'Vérifié' : 'Non vérifié',
          //       style: TextStyle(
          //         color: supplier.verified
          //             ? const Color(0xFF2F80ED)
          //             : Colors.grey,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 24),
          const Text(
            'Produits',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          // Placeholder de produits du fournisseur
          isLoading
              ? CircularProgressIndicator(color: Constant.blue)
              : GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.78,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: List.generate(_produits.length, (i) {
                    final produit = _produits[i];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE6E6EA)),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(produit: produit),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: _imageWidget(produit),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Text(
                                produit.nom,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                '${produit.prix.toStringAsFixed(0)} FCFA',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Constant.colorsBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        ],
      ),
    );
  }

  Widget _imageWidget(Produit s) {
    return s.firstImageUrl == null
        ? Image.asset(
            s.firstImageUrl!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.network(
            s.firstImageUrl!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          );
  }

  Widget _fallback() => Container(
    height: 180,
    color: const Color(0xFFF0F1F5),
    alignment: Alignment.center,
    child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
  );
}
