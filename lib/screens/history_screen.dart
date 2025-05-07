import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/models/transaction_type.dart';
import 'package:spendee/providers/learning_provider.dart';
import '../providers/wallet_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Historial',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Eliminar todo',
              onPressed: () => _showDeleteConfirmationDialog(context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Transacciones'),
              Tab(text: 'Metas Cumplidas'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            _TransactionsTab(),
            _CompletedGoalsTab(),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Estás seguro de que quieres borrar todos los datos?'),
            const SizedBox(height: 10),
            const Text('Escribe "Borrar" para confirmar.'),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Confirmación',
                border: OutlineInputBorder(),
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
            if (controller.text.trim().toLowerCase() == 'borrar') {
              await context.read<WalletProvider>().resetAllData();
              await context.read<LearningProvider>().resetLearningProgress(); // ← Añadido aquí
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Todos los datos han sido eliminados'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Texto incorrecto. Escribe "Borrar" para confirmar.'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab();

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<WalletProvider>().transactions;

    if (transactions.isEmpty) {
      return const Center(
        child: Text('No hay transacciones'),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[transactions.length - 1 - index];
        final isExpense = transaction.type == TransactionType.expense;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            leading: Icon(
              isExpense ? Icons.remove_circle : Icons.add_circle,
              color: isExpense ? Colors.red : Colors.green,
            ),
            title: Text(
              transaction.category,
              style: TextStyle(
                color: isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Fecha: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
            ),
            trailing: Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isExpense ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            children: [
              if (transaction.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Descripción: ${transaction.description}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sin descripción',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CompletedGoalsTab extends StatelessWidget {
  const _CompletedGoalsTab();

  @override
  Widget build(BuildContext context) {
    final completedGoals = context.watch<WalletProvider>().completedGoals;

    if (completedGoals.isEmpty) {
      return const Center(
        child: Text('No hay metas cumplidas'),
      );
    }

    return ListView.builder(
      itemCount: completedGoals.length,
      itemBuilder: (context, index) {
        final goal = completedGoals[completedGoals.length - 1 - index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 32,
            ),
            title: Text(
              goal.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Meta alcanzada: \$${goal.targetAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('Frecuencia: ${goal.frequency}'),
              ],
            ),
            trailing: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
