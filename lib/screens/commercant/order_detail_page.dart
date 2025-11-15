import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:globshopp/screens/commercant/commandes_page.dart'
    show Order, OrderStatus;
import 'package:globshopp/services/commandeGroupeeService.dart';
import 'package:globshopp/model/commandeGroupee.dart' as cg;

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _service = CommandeGroupeeService();
  cg.CommandeGroupee? _data;
  bool _loading = false;
  String? _error;

  static const _text = Color(0xFF0B0B0B);
  static const _sub = Color(0xFF5C5F66);
  static const _cardBorder = Color(0xFFE9E9EE);

  static const _pillInBg = Color(0xFFDFF2DB);
  static const _pillInFg = Color(0xFF2A9A49);
  static const _pillCaBg = Color(0xFFFAD7DA);
  static const _pillCaFg = Color(0xFFD44755);
  static const _pillDoBg = Color(0xFFDCE6F7);
  static const _pillDoFg = Color(0xFF5D7EB7);
  static const _deadlineBg = Color(0xFFFAD7DA);
  static const _deadlineFg = Color(0xFFD44755);

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _service.getAOrderGroupe(widget.order.id);
      setState(() {
        _data = res;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  (String, Color, Color) _statusStyle(OrderStatus s) {
    final backend = _data?.status?.name.toUpperCase();
    switch (backend) {
      case 'TERMINER':
        return ('Terminer', _pillDoBg, _pillDoFg);
      case 'ANNULER':
        return ('Annuler', _pillCaBg, _pillCaFg);
      case 'EXPEDIER':
      case 'ENCOURS':
        return ('En cours', _pillInBg, _pillInFg);
      default:
        switch (s) {
          case OrderStatus.inProgress:
            return ('En cours', _pillInBg, _pillInFg);
          case OrderStatus.canceled:
            return ('Annuler', _pillCaBg, _pillCaFg);
          case OrderStatus.done:
            return ('Terminer', _pillDoBg, _pillDoFg);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _statusStyle(widget.order.status);
    final produit = _data?.produit;
    final imageUrl = produit?.firstImageUrl ?? widget.order.imageUrl;
    final title = produit?.nom ?? widget.order.title;
    final description = (produit?.description?.isNotEmpty == true)
        ? produit!.description
        : 'Le Auralis X9 Pro combine élégance et performance dans un design minimaliste.';
    final moq = (produit?.moq ?? _data?.quantiteRequis ?? 144);
    final prixText = (produit?.prix != null)
        ? '${produit!.prix}fcfa'
        : '140.000fcfa';
    final qActuelle = _data?.quaniteActuelle ?? 100;
    final deadline = _data?.deadline != null
        ? DateFormat('dd/MM/yyyy').format(_data!.deadline)
        : '20/11/2025';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 172, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                // Carte produit + statut
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        color: Color(0x0F000000),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 84,
                          height: 84,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 84,
                            height: 84,
                            color: const Color(0xFFEFF1F6),
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _OrderDetailPageState._text,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: _OrderDetailPageState._sub,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  height: 26,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: fg,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 26,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _OrderDetailPageState._deadlineBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'DeadLine: $deadline',
                                    style: const TextStyle(
                                      color: _OrderDetailPageState._deadlineFg,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // KPI MOQ / Price
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF6E9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Minimum order Quantity',
                              style: TextStyle(
                                color: _OrderDetailPageState._sub,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '$moq pieces',
                              style: const TextStyle(
                                color: Color(0xFFEB8A1A),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(
                                color: _OrderDetailPageState._sub,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              prixText,
                              style: const TextStyle(
                                color: Color(0xFFEB8A1A),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Quantité actuelle (statique)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Quantité actuelle',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '$qActuelle pieces',
                        style: const TextStyle(
                          color: Color(0xFF246BEB),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Liste des membres
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _cardBorder),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 6,
                        ),
                        child: Text(
                          'Liste des membres',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if ((_data?.participation ?? []).isNotEmpty)
                        ..._data!.participation!.map(
                          (p) => _MemberTile(
                            name:
                                '${p.commercantResponseDTO?.prenom ?? ''} ${p.commercantResponseDTO?.nom ?? ''}'
                                    .trim(),
                            since: p.data != null
                                ? DateFormat('dd/MM/yyyy').format(p.data!)
                                : '-',
                            pieces: p.quantite,
                            avatarUrl:
                                (p
                                        .commercantResponseDTO
                                        ?.photoUrl
                                        ?.isNotEmpty ==
                                    true)
                                ? p.commercantResponseDTO!.photoUrl!
                                : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
                          ),
                        ),
                      if ((_data?.participation ?? []).isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4,
                          ),
                          child: Text(
                            'Aucune participation pour le moment.',
                            style: TextStyle(color: _OrderDetailPageState._sub),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Center(
                        child: OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF246BEB),
                            side: BorderSide(color: Color(0xFF246BEB)),
                          ),
                          child: const Text('Voir plus'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // A propos du fournisseur (statique)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'A propos du fournisseur',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _cardBorder),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Text(
                              _data!.produit!.fournisseur!.prenom
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  _data!.produit!.fournisseur!.nom
                                      .substring(0, 1)
                                      .toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (_data?.produit?.fournisseur != null)
                                      ? '${_data!.produit!.fournisseur!.prenom} ${_data!.produit!.fournisseur!.nom}'
                                            .trim()
                                      : 'Fournisseur',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Membre depuis —',
                                  style: TextStyle(
                                    color: _OrderDetailPageState._sub,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  (_data?.produit?.fournisseur != null)
                                      ? 'Contact: ${_data!.produit!.fournisseur!.email}\nTéléphone: ${_data!.produit!.fournisseur!.telephone}'
                                      : 'Informations fournisseur indisponibles.',
                                  style: const TextStyle(
                                    color: _OrderDetailPageState._sub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // En-tête
          Container(
            height: 160,
            width: double.infinity,
            color: const Color(0xFF246BEB),
            padding: const EdgeInsets.only(top: 44, left: 12, right: 12),
            child: Row(
              children: const [
                BackButton(color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Information sur la commande',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.name,
    required this.since,
    required this.pieces,
    required this.avatarUrl,
  });

  final String name;
  final String since;
  final int pieces;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  'Membre depuis : $since',
                  style: const TextStyle(color: _OrderDetailPageState._sub),
                ),
              ],
            ),
          ),
          Text(
            '$pieces pieces',
            style: const TextStyle(
              color: Color(0xFFEB8A1A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
