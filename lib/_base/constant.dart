import 'dart:ui';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constant {
  //Couleurs
  static const blue = Color.fromARGB(255, 61, 116, 182);
  static const blueTransparant = Color.fromARGB(51, 61, 116, 182);
  static const jaune = Color.fromARGB(255, 233, 171, 48);
  static const jauneTransparant = Color.fromARGB(38, 233, 171, 48);
  static const colorsgray = Color.fromARGB(255, 209, 201, 201);
  static const colorsWhite = Color.fromARGB(255, 255, 255, 255);
  static const colorsBlack = Color.fromARGB(255, 0, 0, 0);
  static const grisClaire = Color(0xFF5C5F66);
  static const rougeTransparant = Color.fromARGB(51, 255, 26, 30);
  static const rougeVif = Color.fromARGB(255, 255, 26, 30);
  static const vert = Color.fromARGB(255, 120, 200, 65);
  static const vertTransparant = Color.fromARGB(38, 120, 200, 65);
  static const border = Color(0xFFE6E6E6);

  // static String remoteUrl = dotenv.env["BASE_URL"] ?? '';
  static String remoteUrl = "http://172.20.10.2:8080/api";

  // static String get remoteUrl {
  //   if (Platform.isAndroid) {
  //     return "http://10.0.2.2:8080/api";
  //   } else if (Platform.isIOS) {
  //     return "http://localhost:8080/api";
  //   } else {
  //     // Pour d'autres plateformes (web, desktop, etc.)
  //     return "http://localhost:8080/api";
  //   }
  // }
}
