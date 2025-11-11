import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commandeGroupee.dart';
import 'package:globshopp/model/enum/orderStatus.dart';
import 'package:globshopp/screens/fournisseur/custom/listeCommande.dart';
import 'package:globshopp/services/commandeGroupeeService.dart';

class Commande extends StatefulWidget {
  const Commande({super.key});

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  final CommandeGroupeeService _commandeGroupeeService =
      CommandeGroupeeService();
  final storage = FlutterSecureStorage();
  OrderStatus? selectedStatus;
  bool isLoading = false;

  List<CommandeGroupee> toutesLesCommandes = [];

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

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

  void chargerCommande() async {
    try {
      setState(() {
        isLoading = true;
      });
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Token non trouvé, veuillez vous reconnecter",
              style: TextStyle(color: Constant.colorsWhite),
            ),
            backgroundColor: Constant.blue,
          ),
        );
        return;
      }
      final id = extractIdFromToken(accessToken);
      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Token invalide, veuillez vous reconnecter",
              style: TextStyle(color: Constant.colorsWhite),
            ),
            backgroundColor: Constant.blue,
          ),
        );
        return;
      }
      final conversionId = int.tryParse(id);
      final userCommande = await _commandeGroupeeService
          .getfournisseurCommandes(conversionId!);
      setState(() {
        toutesLesCommandes = userCommande;
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
    chargerCommande();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        backgroundColor: Constant.colorsWhite,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //buton de filtrage
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildButtonTous(),
                    ...OrderStatus.values.map((status) {
                      final bool isSelected = selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 20,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                isSelected
                                    ? Constant.blueTransparant
                                    : Colors.transparent,
                              ),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: isSelected
                                      ? Constant.blue
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedStatus = status;
                              });
                            },
                            child: Text(
                              status.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Constant.blue
                                    : Constant.colorsBlack,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              // listes des commmande grouper
              SizedBox(height: 30),
              isLoading
                  ? CircularProgressIndicator(color: Constant.blue)
                  : Listecommande(commandeGroupee: toutesLesCommandes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonTous() {
    final bool isSelected = selectedStatus == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? Constant.blueTransparant : Colors.transparent,
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: isSelected ? Constant.blue : Colors.grey),
          ),
        ),
        onPressed: () {
          setState(() {
            selectedStatus = null;
          });
        },
        child: Text(
          "Tous",
          style: TextStyle(
            color: isSelected ? Constant.blue : Constant.colorsBlack,
          ),
        ),
      ),
    );
  }
}
