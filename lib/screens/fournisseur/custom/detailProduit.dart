import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/services/produitService.dart';

class DetailProduit extends StatefulWidget {
  final Produit produit;
  const DetailProduit({super.key, required this.produit});

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
  final Produitservice _produitservice = Produitservice();

  bool isLoading = false;

  Future<void> deleteProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (widget.produit.commandeGroupees!.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Constant.blue,
            content: const Text(
              'Inpossible de supprimer une prooduit qui contient des commandes',
              style: TextStyle(color: Constant.colorsWhite),
            ),
          ),
        );
      } else {
        final isDelete = await _produitservice.supprimerUnProduit(
          widget.produit.id!,
        );
        if (isDelete) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Erreur lors de la suppression du produit'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception("Erreur lors de la suppression du produit : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.produit.mediaUrls;
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(height: 6),
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
              SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.produit.nom,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(widget.produit.description),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MOQ : ${widget.produit.moq}",
                        style: TextStyle(color: Constant.jaune),
                      ),
                      Text(
                        "Stock : ${widget.produit.stock}",
                        style: TextStyle(color: Constant.blue),
                      ),
                      Text(
                        "Prix : ${widget.produit.prix}",
                        style: TextStyle(color: Constant.grisClaire),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 100,
                // color: Constant.blueTransparant,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Constant.blue,
                      child: Text(
                        widget.produit.fournisseur!.prenom
                                .substring(0, 1)
                                .toUpperCase() +
                            widget.produit.fournisseur!.nom
                                .substring(0, 1)
                                .toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    SizedBox(width: 26),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.produit.fournisseur!.prenom} ${widget.produit.fournisseur!.nom}",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.produit.fournisseur!.role!.name,
                          style: TextStyle(
                            color: Constant.grisClaire,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text("Bamako/Mali", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 172.91,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {},
                      child: Text("Modifier"),
                    ),
                  ),
                  SizedBox(
                    width: 172.91,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.rougeTransparant,
                        foregroundColor: Constant.rougeVif,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        deleteProduct();
                      },
                      child: isLoading
                          ? CircularProgressIndicator(color: Constant.rougeVif)
                          : Text("Supprimer"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
