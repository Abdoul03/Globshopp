import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/produit.dart';
import 'package:globshopp/screens/fournisseur/custom/detailProduit.dart';

class ListeProduit extends StatefulWidget {
  final Produit produit;
  const ListeProduit({super.key, required this.produit});

  @override
  State<ListeProduit> createState() => _ListeProduitState();
}

class _ListeProduitState extends State<ListeProduit> {
  @override
  Widget build(BuildContext context) {
    final urls = widget.produit.mediaUrls;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduit(produit: widget.produit),
          ),
        );
      },
      child: Container(
        width: 400,
        height: 115,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Constant.colorsgray,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            //Image
            Container(
              margin: EdgeInsets.only(left: 10.0),
              width: 95,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Constant.colorsgray,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: urls.isNotEmpty
                  ? Image.network(
                      widget.produit.mediaUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Center(child: Icon(Icons.image_outlined, size: 48)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.produit.nom,
                      style: TextStyle(
                        color: Constant.colorsBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Prix : ${widget.produit.prix}",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Constant.colorsgray),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "MOQ : ${widget.produit.moq} ${widget.produit.unite.name}",
                          style: TextStyle(color: Constant.jaune),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Stock : ${widget.produit.stock}",
                          style: TextStyle(color: Constant.blue, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
