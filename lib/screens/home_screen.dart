import 'package:flutter/material.dart';
import 'package:spendee/screens/learning/learning_screen.dart';
import 'package:spendee/screens/ticket_scanner_screen.dart';
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
import 'package:spendee/comunity/screens/community_home_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCharts = false;

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
              decoration: const InputDecoration(labelText: 'Nombre de la meta'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Cantidad objetivo', prefixText: '\$'),
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
              final name = nameController.text.trim();
              final amount = double.tryParse(amountController.text);

              if (name.isNotEmpty && amount != null && amount > 0) {
                context.read<WalletProvider>().addNewGoal(name, amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showMascotDialog(BuildContext context, MascotEvent event) {
    String title = '';
    String message = '';
    String imagePath = 'assets/images/mascota_normal.png';

    if (event == MascotEvent.happyIncome) {
      title = '¡Buen trabajo!';
      message = 'Tu mascota está feliz con tu ingreso 🎉 ¡Sigue así!';
      imagePath = 'assets/images/mascota_feliz.png';
    } else if (event == MascotEvent.warningExpense) {
      title = '¡Cuidado!';
      message = 'Tu mascota está triste 😟. Has tenido varios gastos. ¡Administra mejor tu dinero!';
      imagePath = 'assets/images/mascota_triste.png';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, height: 120),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
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
              Provider.of<ThemeProvider>(context).isDarkMode ? Icons.light_mode : Icons.dark_mode,
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
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Spenly',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gestiona tus finanzas',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Aprendizaje'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LearningScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Escanear Ticket'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TicketScannerScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Comunidad'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommunityHomeScreen()),
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
                showDialog(context: context, builder: (context) => const MascotAdviceDialog());
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
            const MascotFeedback(),
            const GoalsSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showCharts = !showCharts;
                    });
                  },
                  icon: Icon(showCharts ? Icons.keyboard_arrow_up : Icons.bar_chart),
                  label: Text(showCharts ? 'Ocultar Gráficas' : 'Mostrar Gráficas'),
                ),
              ),
            ),
            if (showCharts) ...[
              const BalancePieChart(),
              const MonthlyBarChart(),
            ],
            FullReportButton(),
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
