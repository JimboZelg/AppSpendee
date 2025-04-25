import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/models/transaction_type.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isExpense;

  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isExpense,
  });

  void _showGoalSelectionDialog(BuildContext context, double amount, String description) {
    final goals = context.read<WalletProvider>().goals;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Dónde deseas agregar el ingreso?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Cuenta General'),
              onTap: () {
                final transaction = Transaction(
                  id: DateTime.now().toString(),
                  amount: amount,
                  category: title,
                  date: DateTime.now(),
                  type: TransactionType.income,
                  description: description,
                );
                context.read<WalletProvider>().addTransaction(
                      description,
                      transaction,
                    );

                Navigator.pop(context);
              },
            ),
            const Divider(),
            ...goals.map((goal) => ListTile(
                  leading: const Icon(Icons.flag),
                  title: Text(goal.name),
                  subtitle: Text('${goal.currentAmount.toStringAsFixed(0)}/${goal.targetAmount.toStringAsFixed(0)}'),
                  onTap: () async {
                    await context.read<WalletProvider>().addToGoal(goal.id, amount);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showAmountDialog(BuildContext context) {
    final textController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isExpense ? 'Agregar Gasto' : 'Agregar Ingreso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final parsedAmount = double.tryParse(textController.text);
              if (parsedAmount != null && parsedAmount > 0) {
                Navigator.pop(context);
                if (isExpense) {
                  final transaction = Transaction(
                    id: DateTime.now().toString(),
                    amount: parsedAmount,
                    category: title,
                    date: DateTime.now(),
                    type: TransactionType.expense,
                    description: descriptionController.text,
                  );
                  final success = await context.read<WalletProvider>().addTransaction(
                    descriptionController.text,
                    transaction,
                  );

                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ No puedes gastar más de lo que tienes disponible."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                } else {
                  _showGoalSelectionDialog(context, parsedAmount, descriptionController.text);
                }
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAmountDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isExpense ? Colors.red[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para agregar',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
