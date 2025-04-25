import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction_type.dart';

class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final Map<String, double> monthlyIncomes = {};
    final Map<String, double> monthlyExpenses = {};

    final formatter = DateFormat('MM-yyyy');

    for (var tx in walletProvider.transactions) {
      if (tx.description == 'goal') continue;
      final monthYear = formatter.format(tx.date);
      if (tx.type == TransactionType.income) {
        monthlyIncomes[monthYear] = (monthlyIncomes[monthYear] ?? 0) + tx.amount;
      } else {
        monthlyExpenses[monthYear] = (monthlyExpenses[monthYear] ?? 0) + tx.amount;
      }
    }

    final allMonths = {...monthlyIncomes.keys, ...monthlyExpenses.keys}.toList()..sort();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresos vs Gastos Mensuales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= allMonths.length) return const Text('');
                          return Text(allMonths[index], style: const TextStyle(fontSize: 10));
                        },
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10));
                        },
                        reservedSize: 40,
                        interval: 1000,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: List.generate(allMonths.length, (i) {
                    final month = allMonths[i];
                    final income = monthlyIncomes[month] ?? 0;
                    final expense = monthlyExpenses[month] ?? 0;

                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(toY: income, color: Colors.green, width: 8),
                        BarChartRodData(toY: expense, color: Colors.red, width: 8),
                      ],
                    );
                  }),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
