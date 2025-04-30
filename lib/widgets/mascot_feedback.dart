import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class MascotFeedback extends StatelessWidget {
  const MascotFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final walletProvider = context.watch<WalletProvider>();
      final mascotMood = walletProvider.mascotMood;
      final savingsMessage = walletProvider.getMascotMessage();

      String imagePath = 'assets/images/mascota_normal.png';
      String moodMessage = "Recuerda seguir revisando tu ahorro.";

      if (mascotMood == "feliz") {
        imagePath = 'assets/images/mascota_feliz.png';
        moodMessage = "¡Estoy muy feliz por tus ingresos! 🎉 ¡Sigue así!";
      } else if (mascotMood == "triste") {
        imagePath = 'assets/images/mascota_triste.png';
        moodMessage = "Estoy un poco preocupado 😟. Has hecho varios gastos. ¡Intenta ahorrar un poco más!";
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  height: 100,
                ),
                const SizedBox(height: 12),
                Text(
                  moodMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        savingsMessage,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e, stacktrace) {
      debugPrint('Error en MascotFeedback: $e');
      debugPrint('$stacktrace');

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.redAccent,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Error al cargar a Spenly',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }
}
