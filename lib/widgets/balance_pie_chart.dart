
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction_type.dart';

class BalancePieChart extends StatelessWidget {
  const BalancePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    double income = 0;
    double expenses = 0;

    for (final tx in walletProvider.transactions) {
      if (tx.date.month == currentMonth && tx.date.year == currentYear) {
        if (tx.type == TransactionType.income && tx.description != 'goal') {
          income += tx.amount;
        } else if (tx.type == TransactionType.expense) {
          expenses += tx.amount;
        }
      }
    }

    final double ahorro = income - expenses;

    List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: income,
        title: 'Ingresos',
        color: Colors.green,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        value: expenses,
        title: 'Gastos',
        color: Colors.red,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      if (ahorro > 0)
        PieChartSectionData(
          value: ahorro,
          title: 'Ahorro',
          color: Colors.blueAccent,
          radius: 60,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
    ];

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Distribución Mensual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
