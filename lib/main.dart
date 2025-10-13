import 'package:flutter/material.dart';
import 'package:globshopp/screens/onboarding_carousel.dart';

void main() {
  runApp(const GlobalShopperApp());
}

class GlobalShopperApp extends StatelessWidget {
  const GlobalShopperApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Global Shopper',
      theme: ThemeData(useMaterial3: true),
      home: const OnboardingCarousel(),
    );
  }
}
