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
      final message = walletProvider.getMascotMessage();

      String imagePath = 'assets/images/mascota_normal.png'; // Default

      if (mascotMood == "feliz") {
        imagePath = 'assets/images/mascota_feliz.png';
      } else if (mascotMood == "triste") {
        imagePath = 'assets/images/mascota_triste.png';
      } else if (mascotMood == "normal") {
        imagePath = 'assets/images/mascota_normal.png'; // o podrías tener una "neutral_mascot.png" si quieres
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.monetization_on, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 16),
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
