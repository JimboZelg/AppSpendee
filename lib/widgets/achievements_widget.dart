
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class AchievementsWidget extends StatelessWidget {
  const AchievementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final goodSavings = provider.totalGoodSavingsMonths;
    final goalsDone = provider.totalGoalsCompleted;
    final consistency = provider.consistentMonths;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("🎖️ Tus Logros Financieros", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text("⭐ Ahorros sobresalientes (10%+): $goodSavings"),
              Text("🏁 Metas cumplidas: $goalsDone"),
              Text("📆 Meses con ahorro: $consistency"),
            ],
          ),
        ),
      ),
    );
  }
}
