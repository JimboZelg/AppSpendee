import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonthYear = "${now.month.toString().padLeft(2, '0')}-${now.year}";

    final walletProvider = context.watch<WalletProvider>();
    final recommendation = walletProvider.getRecommendationForMonth(currentMonthYear);
    final monthlySavings = walletProvider.getMonthlySavingsPercentages();
    final keys = monthlySavings.keys.toList()..sort();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recomendación para este mes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            recommendation,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Comparativa Mensual',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final month = keys[index];
              final savingPercent = monthlySavings[month];
              return ListTile(
                title: Text("Mes: $month"),
                trailing: Text("${savingPercent!.toStringAsFixed(1)}%"),
              );
            },
          ),
        ],
      ),
    );
  }
}
