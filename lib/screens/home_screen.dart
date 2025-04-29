import 'package:flutter/material.dart';
import 'package:spendee/screens/learning/learning_screen.dart';
import '../widgets/recommendations_widget.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import 'package:spendee/providers/theme_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/balance_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';
import '../widgets/full_report_button.dart';
import '../widgets/transaction_card.dart';
import '../widgets/goals_section.dart';
import '../widgets/mascot_feedback.dart';
import '../widgets/achievements_widget.dart';
import '../widgets/mascot_advice_dialog.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddGoalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la meta',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Cantidad objetivo',
                prefixText: '\$',
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
            onPressed: () {
              final name = nameController.text.trim();
              final amount = double.tryParse(amountController.text);

              if (name.isNotEmpty && amount != null && amount > 0) {
                context.read<WalletProvider>().addNewGoal(
                  name,
                  amount,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Spenly',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Spenly',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gestiona tus finanzas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
            ListTile(
  leading: Icon(Icons.school),
  title: Text('Aprendizaje'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LearningScreen()),
    );
  },
),

          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const MascotAdviceDialog(),
                );
              },
              child: const SummaryCard(),
            ),
            AchievementsWidget(),
            RecommendationsWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TransactionCard(
                      title: 'Gastos',
                      amount: context.watch<WalletProvider>().totalExpenses,
                      isExpense: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TransactionCard(
                      title: 'Ingresos',
                      amount: context.watch<WalletProvider>().totalIncome,
                      isExpense: false,
                    ),
                  ),
                ],
              ),
            ),
            const GoalsSection(),
            BalancePieChart(),
            MonthlyBarChart(),
            FullReportButton(),
            const MascotFeedback(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
