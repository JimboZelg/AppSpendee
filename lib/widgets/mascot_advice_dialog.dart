import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class MascotAdviceDialog extends StatefulWidget {
  const MascotAdviceDialog({super.key});

  @override
  State<MascotAdviceDialog> createState() => _MascotAdviceDialogState();
}

class _MascotAdviceDialogState extends State<MascotAdviceDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String _advice;

  final List<String> _advices = [
    "Ahorra primero, gasta después.",
    "Destina al menos el 20% de tus ingresos al ahorro.",
    "Evita compras impulsivas, haz una lista.",
    "Busca siempre ofertas y descuentos.",
    "Planifica tus gastos mensuales.",
    "Usa efectivo para controlar mejor el gasto.",
    "Establece metas de ahorro claras.",
    "No gastes en lo que no necesitas.",
    "Revisa tus gastos pequeños, se acumulan rápido.",
    "Invierte en tu educación financiera."
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );

    _advice = _advices[Random().nextInt(_advices.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonthYear = "\${now.month.toString().padLeft(2, '0')}-\${now.year}";
    final walletProvider = context.read<WalletProvider>();
    final recommendation = walletProvider.getRecommendationForMonth(currentMonthYear);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value),
                  child: child,
                );
              },
              child: const Icon(Icons.pets, size: 80, color: Colors.blueAccent),
            ),
            const SizedBox(height: 16),
            Text(
              _advice,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Consejo del mes:",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Text(
              recommendation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("¡Genial!"),
            )
          ],
        ),
      ),
    );
  }
}
