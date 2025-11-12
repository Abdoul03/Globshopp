import 'dart:io';

import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/caracteristique.dart';
import 'package:globshopp/model/categorie.dart';
import 'package:globshopp/model/enum/uniteProduit.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/services/categorieService.dart';
import 'package:globshopp/services/produitService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remixicon/remixicon.dart';

class ModifierProduit extends StatefulWidget {
  final Produit produit;
  const ModifierProduit({super.key, required this.produit});

  @override
  State<ModifierProduit> createState() => _ModifierProduitState();
}

class _ModifierProduitState extends State<ModifierProduit> {
  final Produitservice _produitservice = Produitservice();
  final CategorieService _categorieService = CategorieService();

  final TextEditingController _nom = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _prix = TextEditingController();
  final TextEditingController _moq = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  // final TextEditingController _unite = TextEditingController();

  final TextEditingController _caracteristiqueNom = TextEditingController();
  final TextEditingController _caracteristiqueValeur = TextEditingController();

  List<Caracteristique> _caracteristique = [];
  List<Categorie> _categories = [];
  Categorie? _selectedCategorie;
  bool isLoading = false;

  Uniteproduit? _uniteproduit = Uniteproduit.PIECES;

  void setUniterProduit(Uniteproduit? value) {
    setState(() {
      _uniteproduit = value;
    });
  }

  List<File> medias = [];
  final ImagePicker _picker = ImagePicker();

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Constant.colorsgray),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Constant.border, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Constant.blue, width: 1.4),
    ),
  );

  //Style du button Ajouter
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Constant.blue,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(52)),
    ),
  );

  Future<void> chargerCategorie() async {
    try {
      setState(() {
        isLoading = true;
      });
      final categorie = await _categorieService.getAllCategoeri();
      setState(() {
        _categories = categorie;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      throw Exception('Erreur lors de la récupération des categories : $e');
    }
  }

  void _ajouterCaracteristique() {
    final nom = _caracteristiqueNom.text.trim();
    final value = _caracteristiqueValeur.text.trim();

    if (nom.isEmpty || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Constant.colorsWhite,
          content: Text(
            "Tous les champs de la contrepartie doivent être remplis.",
            style: TextStyle(color: Constant.blue),
          ),
        ),
      );
      return;
    }

    setState(() {
      _caracteristique.add(Caracteristique(nom: nom, valeur: value));

      // Réinitialiser les champs
      _caracteristiqueNom.clear();
      _caracteristiqueValeur.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        backgroundColor: Constant.colorsWhite,
        surfaceTintColor: Colors.transparent,
        title: Text("Modification de ${widget.produit.nom}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Champ Image
                const Text(
                  'Image du produit',
                  style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Constant.border, width: 1.2),
                    color: Constant.colorsgray.withOpacity(0.1),
                  ),
                  child: Stack(
                    children: [
                      // Zone principale pour afficher l'image en grand
                      Positioned.fill(
                        child: medias.isNotEmpty
                            ? Image.file(medias.last, fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  'Aucune image sélectionnée',
                                  style: TextStyle(color: Constant.colorsgray),
                                ),
                              ),
                      ),

                      // Liste des aperçus en bas
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          height: 100, // hauteur du carrousel d'aperçu
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: medias.length + 1,
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              if (index == medias.length) {
                                return GestureDetector(
                                  onTap: () async {
                                    final XFile? image = await _picker
                                        .pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 80,
                                        );
                                    if (image != null) {
                                      setState(() {
                                        medias.add(File(image.path));
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Constant.colorsgray.withOpacity(
                                        0.2,
                                      ),
                                      border: Border.all(
                                        color: Constant.border,
                                      ),
                                    ),
                                    child: const Icon(
                                      RemixIcons.folder_image_fill,
                                      color: Constant.blue,
                                    ),
                                  ),
                                );
                              } else {
                                return Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Constant.border,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          medias[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            medias.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black54,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                //Nom
                const Text(
                  'Nom',
                  style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nom,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez le nom de votre produit'),
                ),
                const SizedBox(height: 16),

                //Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _description,
                  textInputAction: TextInputAction.next,
                  decoration: _decoration('Entrez la description'),
                ),
                const SizedBox(height: 16),

                //Prix
                const Text(
                  'Prix',
                  style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _prix,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration('Entrez votre prix'),
                ),
                const SizedBox(height: 16),

                // Quantite minimum de commande
                const Text(
                  'Quantite minimum de commande',
                  style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _moq,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration(
                    'Entrez votre Quantite minimum de commande',
                  ),
                ),
                const SizedBox(height: 16),

                //Stok
                const Text(
                  'Quantite en Stock',
                  style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _stock,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration('Entrez la quantitée en stock'),
                ),
                const SizedBox(height: 16),

                //Uniter
                SizedBox(
                  height: 60,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          final options = [
                            Uniteproduit.PIECES,
                            Uniteproduit.KG,
                            Uniteproduit.LOT,
                            Uniteproduit.PAIRES,
                            Uniteproduit.ENSEMBLE,
                          ];
                          final labels = [
                            'PIÈCES',
                            'KG',
                            'LOT',
                            'PAIRES',
                            'ENSEMBLE',
                          ];
                          final unite = options[index];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<Uniteproduit>(
                                value: unite,
                                groupValue: _uniteproduit,
                                onChanged: setUniterProduit,
                                activeColor: Constant.blue,
                              ),
                              Text(labels[index]),
                            ],
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: 5,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<Categorie>(
                  dropdownColor: Colors.white,
                  focusColor: Constant.blue,
                  value: _selectedCategorie,
                  items: _categories.map((categorie) {
                    return DropdownMenuItem(
                      value: categorie,
                      child: Text(categorie.nom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategorie = value;
                    });
                  },
                  decoration: InputDecoration(
                    focusColor: Constant.blue,
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                _buildCaracteristique(),

                const SizedBox(height: 16),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    onPressed: _ajouterCaracteristique,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    label: Text("Ajouter"),
                  ),
                ),
                SizedBox(height: 10),
                ..._caracteristique.map(
                  (c) => ListTile(
                    title: Text(c.nom),
                    subtitle: Text("Nom: ${c.nom} | valeur: ${c.valeur}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _caracteristique.remove(c);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                //Bouton S’inscrire
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final nom = _nom.text.trim();
                      final description = _description.text.trim();
                      final prix = double.tryParse(_prix.text.trim());
                      final moq = int.tryParse(_moq.text.trim());
                      final stock = int.tryParse(_stock.text.trim());

                      final nomCaracteristique = _caracteristiqueNom.text
                          .trim();
                      final valueCaracteristique = _caracteristiqueValeur.text
                          .trim();

                      if (nom.isEmpty ||
                          prix == null ||
                          description.isEmpty ||
                          moq == null ||
                          stock == null ||
                          _selectedCategorie == null ||
                          _uniteproduit == null ||
                          nomCaracteristique.isEmpty ||
                          valueCaracteristique.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Tous les champs doivent être remplis .",
                            ),
                          ),
                        );
                        return;
                      }

                      if (medias.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Ajoutez au moins un média.")),
                        );
                        return;
                      }
                      _caracteristique.add(
                        Caracteristique(
                          nom: nomCaracteristique,
                          valeur: valueCaracteristique,
                        ),
                      );

                      final produit = Produit(
                        nom: nom,
                        description: description,
                        prix: prix,
                        moq: moq,
                        stock: stock,
                        unite: _uniteproduit!,
                        categorieId: _selectedCategorie!.id!,
                        caracteristiques: _caracteristique,
                      );

                      // _produitservice.createProduit(produit, medias);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Constant.colorsWhite,
                          content: Text(
                            "Produit Ajouter avec succes.",
                            style: TextStyle(color: Constant.blue),
                          ),
                        ),
                      );

                      _nom.clear();
                      _description.clear();
                      _prix.clear();
                      _moq.clear();
                      _stock.clear();

                      _caracteristiqueNom.clear();
                      _caracteristiqueValeur.clear();

                      setState(() {
                        _selectedCategorie = null;
                        _caracteristique.clear();
                        medias.clear();
                      });
                    },
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
                    child: isLoading
                        ? CircularProgressIndicator(color: Constant.colorsWhite)
                        : const Text("Modifier"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaracteristique() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Caracteristique", style: TextStyle(fontSize: 19)),
        const SizedBox(height: 16),
        Text(
          'Nom',
          style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _caracteristiqueNom,
          textInputAction: TextInputAction.next,
          decoration: _decoration('Entrez le nom'),
        ),
        const SizedBox(height: 16),
        Text(
          'Valeur',
          style: TextStyle(fontSize: 14, color: Constant.colorsBlack),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _caracteristiqueValeur,
          textInputAction: TextInputAction.next,
          decoration: _decoration('Entrez la valeur'),
        ),
      ],
    );
  }
}
