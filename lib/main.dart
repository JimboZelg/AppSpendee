import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/wallet_provider.dart';
import 'models/transaction_adapter.dart';
import 'models/goal_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //Limpia datos anteriores que puedan tener typeId desconocido (32)
  //await Hive.deleteBoxFromDisk('transactions');
  //await Hive.deleteBoxFromDisk('goals');
  //await Hive.deleteBoxFromDisk('completed_goals');

  // Registra los adaptadores correctamente con sus IDs reales
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TransactionAdapter()); // typeId: 1
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(GoalAdapter()); // typeId: 2
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletProvider(),
      child: MaterialApp(
        title: 'Spendee',
        theme: ThemeData(
          primaryColor: const Color(0xFF87CEEB),
          scaffoldBackgroundColor: const Color(0xFF87CEEB),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF87CEEB),
            primary: const Color(0xFF87CEEB),
            secondary: const Color(0xFFFFEB3B),
            error: const Color(0xFFFF0000),
            tertiary: const Color(0xFF4CAF50),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
