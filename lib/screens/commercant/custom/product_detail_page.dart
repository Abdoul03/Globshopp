import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/enum/orderStatus.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/commercant/joinGroupOrder.dart';
import 'package:globshopp/screens/commercant/supplier_detail_page.dart';
import 'package:globshopp/services/produitService.dart';
import '../group_order_page.dart';
import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/screens/fournisseur/custom/detailCommande.dart';

class ProductDetailPage extends StatefulWidget {
  final Produit produit;
  const ProductDetailPage({super.key, required this.produit});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final storage = FlutterSecureStorage();
  final Produitservice _produitservice = Produitservice();

  String? extractIdFromToken(String accessToken) {
    try {
      // Le token a la forme header.payload.signature
      final parts = accessToken.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      // Base64Url decoding
      var normalized = base64Url.normalize(payload);
      final payloadMap = jsonDecode(utf8.decode(base64Url.decode(normalized)));

      if (payloadMap is! Map<String, dynamic>) return null;
      return payloadMap['sub'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  // Retourne la commande groupée où le commerçant participe (sinon null)
  // Utilise l'API pour récupérer la commande où l'utilisateur participe
  Future<CommandeGroupee?> _getUserGroupOrder() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;
    final userIdStr = extractIdFromToken(accessToken);
    if (userIdStr == null) return null;
    final userId = int.tryParse(userIdStr);
    if (userId == null) return null;

    print('DEBUG _getUserGroupOrder: userId = $userId');

    try {
      // L'API retourne la commande où l'utilisateur participe pour ce produit
      // Si l'utilisateur ne participe pas, l'API retourne une erreur (404 généralement)
      final CommandeGroupee userOrder = await _produitservice.getParticipation(
        widget.produit.id!,
      );

      print(
        'DEBUG _getUserGroupOrder: API retourne commande ID=${userOrder.id}, status=${userOrder.status}',
      );

      // Vérifie dans les commandes du produit si cette commande existe avec un statut différent
      // (plus à jour que celui retourné par l'API)
      final allGroupOrders = widget.produit.commandeGroupees ?? [];
      final matchingOrder = allGroupOrders.firstWhere(
        (cmd) => cmd.id == userOrder.id,
        orElse: () => userOrder, // Si pas trouvée, utilise celle de l'API
      );

      print(
        'DEBUG _getUserGroupOrder: commande dans produit ID=${matchingOrder.id}, status=${matchingOrder.status}',
      );

      // Retourne toujours la commande si l'utilisateur y participe, peu importe son statut
      // La logique du bouton décidera quoi afficher selon le statut
      print(
        'DEBUG _getUserGroupOrder: retourne commande ID=${matchingOrder.id}',
      );
      return matchingOrder;
    } on Exception catch (e) {
      // Si l'API retourne une erreur, cela peut signifier :
      // 1. L'utilisateur ne participe pas (cas normal)
      // 2. L'API a un problème
      print('DEBUG _getUserGroupOrder: Exception de l\'API: $e');

      // On essaie quand même de chercher dans les commandes du produit
      // en utilisant l'ID utilisateur pour vérifier les participations
      // Mais comme les participations ne sont pas chargées, on ne peut pas vraiment vérifier
      // Donc on retourne null
      return null;
    } catch (e) {
      // Erreur inattendue
      print('DEBUG _getUserGroupOrder: erreur inattendue: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.produit.mediaUrls;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────── AppBar (retour) ───────────
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(height: 6),

              // ─────────── Image produit ───────────
              // if (produit.mediaUrls.isNotEmpty)
              //   SizedBox(
              //     height: 200,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: produit.mediaUrls.length,
              //       itemBuilder: (context, index) {
              //         final url = produit.mediaUrls[index];
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //           child: Image.network(url, fit: BoxFit.cover),
              //         );
              //       },
              //     ),
              //   )
              // else
              //   const Center(child: Icon(Icons.image_outlined, size: 36)),
              AspectRatio(
                aspectRatio: 3 / 3.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: const Color(0xFFF7F7F9),
                    child: urls.isNotEmpty
                        ? PageView.builder(
                            itemCount: urls.length,
                            itemBuilder: (_, index) {
                              final imageUrl = urls[index];
                              return Hero(
                                tag: imageUrl,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.image_outlined, size: 48),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(Icons.image_outlined, size: 48),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ─────────── Bloc prix + MOQ ───────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Constant.colorsgray,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Constant.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Prix
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.produit.prix}",
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Constant.colorsBlack,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Prix unitaire',
                          style: TextStyle(
                            fontSize: 11,
                            color: Constant.grisClaire,
                          ),
                        ),
                      ],
                    ),

                    // MOQ
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'MOQ:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Constant.jaune,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${widget.produit.moq}",
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                            color: Constant.jaune,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ─────────── Titre produit ───────────
              Text(
                widget.produit.nom,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Constant.colorsBlack,
                ),
              ),
              const SizedBox(height: 6),

              // ─────────── Description ───────────
              Text(
                widget.produit.description,
                style: TextStyle(fontSize: 12, height: 1.4),
              ),

              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Caracteristique",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  ListView.separated(
                    itemCount: widget.produit.caracteristiques.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final caracteristique =
                          widget.produit.caracteristiques[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${caracteristique.nom} :",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(caracteristique.valeur),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ─────────── Carte Fournisseur ───────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Constant.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.store_mall_directory_outlined,
                        size: 17,
                        color: Constant.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupplierDetailPage(
                              supplier: widget.produit.fournisseur!,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.produit.fournisseur!.prenom} ${widget.produit.fournisseur!.nom}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Constant.colorsBlack,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Fournisseur Grossiste',
                              style: TextStyle(
                                fontSize: 11,
                                color: Constant.jaune,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ─────────── Bouton principal (FutureBuilder) ───────────
              FutureBuilder<CommandeGroupee?>(
                // Le future récupère la commande groupée où l'utilisateur participe (ou null)
                future: _getUserGroupOrder(),
                builder: (context, snapshot) {
                  final allGroupOrders = widget.produit.commandeGroupees ?? [];

                  // 1) Le produit a-t-il AU MOINS une commande groupée ?
                  final hasAnyOrder = allGroupOrders.isNotEmpty;

                  // 2) Y a-t-il au moins une commande active (non TERMINER) ?
                  final hasActiveOrder = allGroupOrders.any(
                    (cmd) => cmd.status != OrderStatus.TERMINER,
                  );

                  // 3) Toutes les commandes sont-elles TERMINER ?
                  final allOrdersFinished = hasAnyOrder && !hasActiveOrder;

                  final isLoading =
                      snapshot.connectionState == ConnectionState.waiting;

                  // 3) Commande dans laquelle l'utilisateur participe (peut être null)
                  final userOrder = snapshot.data;

                  // DEBUG: Logs pour comprendre le comportement
                  print('DEBUG BOUTON:');
                  print('  - hasAnyOrder: $hasAnyOrder');
                  print('  - hasActiveOrder: $hasActiveOrder');
                  print('  - allOrdersFinished: $allOrdersFinished');
                  print(
                    '  - userOrder: ${userOrder?.id} (status: ${userOrder?.status})',
                  );
                  print('  - isLoading: $isLoading');

                  String label;
                  VoidCallback? onPressed;

                  if (isLoading) {
                    // Chargement en cours
                    label = 'Chargement...';
                    onPressed = null;
                  } else if (userOrder != null) {
                    print(
                      'DEBUG: userOrder != null, status: ${userOrder.status}',
                    );
                    // L'utilisateur participe à une commande pour ce produit
                    if (userOrder.status == OrderStatus.TERMINER) {
                      // La commande de l'utilisateur est TERMINÉE -> Créer une nouvelle commande
                      label = 'Créer une commande';
                      onPressed = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                GroupOrderPage(produit: widget.produit),
                          ),
                        );
                      };
                    } else {
                      // La commande de l'utilisateur est active (EN COURS, etc.) -> Voir les détails
                      label = 'Voir les détails de la commande';
                      onPressed = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailCommande(commande: userOrder),
                          ),
                        );
                      };
                    }
                  } else if (allOrdersFinished) {
                    // Toutes les commandes sont TERMINÉE et l'utilisateur n'y participe pas
                    // -> On propose de créer une nouvelle commande
                    print('DEBUG: Cas allOrdersFinished (toutes terminées)');
                    label = 'Créer une commande';
                    onPressed = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GroupOrderPage(produit: widget.produit),
                        ),
                      );
                    };
                  } else if (hasActiveOrder) {
                    // Le produit a au moins une commande groupée active (EN COURS)
                    // mais l'utilisateur n'en fait pas partie
                    // -> Rejoindre la commande
                    print('DEBUG: Cas hasActiveOrder (rejoindre)');
                    label = 'Rejoindre la commande';
                    onPressed = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              JoinGroupOrder(produit: widget.produit),
                        ),
                      );
                    };
                  } else {
                    // Le produit n'a AUCUNE commande groupée
                    // -> Créer une commande
                    print('DEBUG: Cas aucune commande (créer)');
                    label = 'Créer une commande';
                    onPressed = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GroupOrderPage(produit: widget.produit),
                        ),
                      );
                    };
                  }

                  return SizedBox(
                    height: 44,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: onPressed,
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
