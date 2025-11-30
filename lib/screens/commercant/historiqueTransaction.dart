import 'package:flutter/material.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/transaction.dart';
import 'package:globshopp/services/transactionService.dart';
import 'package:intl/intl.dart';

class Historiquetransaction extends StatefulWidget {
  const Historiquetransaction({super.key});

  @override
  State<Historiquetransaction> createState() => _HistoriquetransactionState();
}

class _HistoriquetransactionState extends State<Historiquetransaction> {
  final Transactionservice _transactionservice = Transactionservice();

  List<Transaction> transactions = [];
  bool _loading = true;

  Future<void> chargerTransaction() async {
    try {
      final response = await _transactionservice.getCommercantTransaction();
      setState(() {
        _loading = false;
        transactions = response;
      });
    } catch (e) {
      setState(() => _loading = false);
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void initState() {
    chargerTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.colorsWhite,
      appBar: AppBar(
        backgroundColor: Constant.colorsWhite,
        title: const Text(
          "Historique des transactions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        color: Constant.blue,
        backgroundColor: Constant.colorsWhite,
        onRefresh: chargerTransaction,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: transactions.length,
                itemBuilder: (context, i) {
                  final t = transactions[i];
                  final isCredit =
                      t.transactionType == "credit"; // adapte selon ton API
                  final montantColor = isCredit ? Colors.green : Colors.red;
                  final icon = isCredit
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;

                  final date = DateFormat('dd/MM/yyyy').format(t.date!);

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Constant.colorsWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: montantColor.withOpacity(0.15),
                          child: Icon(icon, color: montantColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${t.montant} F CFA",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: montantColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
