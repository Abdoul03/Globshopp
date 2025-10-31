import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/commercant/custom/kvLine.dart';
import 'package:globshopp/services/commandeGroupeeService.dart';

class JoinGroupOrder extends StatefulWidget {
  final Produit produit;
  const JoinGroupOrder({super.key, required this.produit});

  @override
  State<JoinGroupOrder> createState() => _JoinGroupOrderState();
}

class _JoinGroupOrderState extends State<JoinGroupOrder> {
  final CommandeGroupeeService _commandeGroupeeService =
      CommandeGroupeeService();
  final _qtyCtrl = TextEditingController();
  bool _isLoading = false;
  double _montantTotal = 0;

  void calcul(String text) {
    setState(() {
      if (text.isEmpty) {
        _montantTotal = 0;
      } else {
        final qte = double.tryParse(text) ?? 0;
        _montantTotal = qte * widget.produit.prix;
      }
    });
  }

  //Formatage manuel
  String _fmtMoney(num v) {
    final s = v.toStringAsFixed(0);
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return '${s.replaceAllMapped(reg, (m) => '.')} fcfa';
  }

  String _fmtInt(int n) {
    final s = n.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 8,
              top: 4,
              child: IconButton(
                padding: const EdgeInsets.all(8),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                color: Colors.black87,
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Contenu principal
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),

                      const Text(
                        'Rejoindre la commande groupée',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Constant.colorsBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Vous aller Rejoindre la commande goupée pour le\nproduit : ${widget.produit.nom}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Constant.grisClaire,
                          fontSize: 13.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Prix unitaire + MOQ
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          KVLine(
                            k: 'Prix unitaire :',
                            v: _fmtMoney(widget.produit.prix),
                          ),
                          const SizedBox(height: 8),
                          KVLine(
                            k: 'Moq :',
                            v: '${_fmtInt(widget.produit.moq)} ',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _qtyCtrl,
                          onChanged: calcul,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantité',
                            hintText: 'Entrez la quantité',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Constant.border,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Constant.blue,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Montant à payer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Montant Total",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _fmtMoney(_montantTotal),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Constant.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),

                      // Bouton Créer
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.blue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final quantite = int.tryParse(_qtyCtrl.text.trim());

                            if (quantite == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Constant.blue,
                                  content: Text(
                                    "Veillez vournir votre Quantité .",
                                    style: TextStyle(
                                      color: Constant.colorsWhite,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }

                            // Action à faire ici
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Constant.colorsWhite,
                                )
                              : Text(
                                  'Rejoindre',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
