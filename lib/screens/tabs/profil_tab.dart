import 'package:flutter/material.dart';

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return ListView(
      padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
      children: const [
        Text('Profil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        SizedBox(height: 12),
        Text('Contenu profil ici...'),
      ],
    );
  }
}
