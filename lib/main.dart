import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/wallet_provider.dart';
import 'providers/learning_provider.dart';
import 'providers/theme_provider.dart';
import 'models/transaction_adapter.dart';
import 'models/goal_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Limpia datos anteriores (opcional)
  // await Hive.deleteBoxFromDisk('transactions');
  // await Hive.deleteBoxFromDisk('goals');
  // await Hive.deleteBoxFromDisk('completed_goals');

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TransactionAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(GoalAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => LearningProvider()..loadProgress()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Spenly',
            theme: ThemeData(
              brightness: Brightness.light,
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
            darkTheme: ThemeData.dark(), 
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
