import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/goal.dart';

class WalletProvider with ChangeNotifier {
  static const String transactionsBoxName = 'transactions';
  static const String goalsBoxName = 'goals';
  static const String completedGoalsBoxName = 'completed_goals';

  late final Box<Transaction> _transactionsBox;
  late final Box<Goal> _goalsBox;
  late final Box<Goal> _completedGoalsBox;

  List<Transaction> _transactions = [];
  List<Goal> _goals = [];
  List<Goal> _completedGoals = [];

  WalletProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      _transactionsBox = await Hive.openBox<Transaction>(transactionsBoxName);
      _goalsBox = await Hive.openBox<Goal>(goalsBoxName);
      _completedGoalsBox = await Hive.openBox<Goal>(completedGoalsBoxName);
      await loadData();
    } catch (e) {
      debugPrint('Error initializing Hive: \$e');
      _initializeDefaultData();
    }
  }

  void _initializeDefaultData() {
    _goals = [
      Goal(id: '1', name: 'Vacaciones', currentAmount: 10500, targetAmount: 15000, frequency: 'Mensual'),
      Goal(id: '2', name: 'Titulación', currentAmount: 1000, targetAmount: 4000, frequency: 'Semanal'),
      Goal(id: '3', name: 'GTA VI', currentAmount: 1260, targetAmount: 1400, frequency: 'Semanal'),
    ];
  }

  Future<void> loadData() async {
    try {
      _transactions = _transactionsBox.values.toList();
      _goals = _goalsBox.values.toList();
      _completedGoals = _completedGoalsBox.values.toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading data: \$e');
    }
  }

  Future<void> _saveTransactions() async {
    try {
      await _transactionsBox.clear();
      await _transactionsBox.addAll(_transactions);
    } catch (e) {
      debugPrint('Error saving transactions: \$e');
    }
  }

  Future<void> _saveGoals() async {
    try {
      await _goalsBox.clear();
      await _goalsBox.addAll(_goals);
    } catch (e) {
      debugPrint('Error saving goals: \$e');
    }
  }

  Future<void> _saveCompletedGoals() async {
    try {
      await _completedGoalsBox.clear();
      await _completedGoalsBox.addAll(_completedGoals);
    } catch (e) {
      debugPrint('Error saving completed goals: \$e');
    }
  }

  List<Transaction> get transactions => _transactions;
  List<Goal> get goals => _goals;
  List<Goal> get completedGoals => _completedGoals;

  double get totalBalance {
    return _transactions.fold(0, (sum, transaction) {
      if (transaction.description != 'goal') {
        return sum + (transaction.type == TransactionType.expense ? -transaction.amount : transaction.amount);
      }
      return sum;
    });
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income && t.description != 'goal')
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  Future<bool> addTransaction(String description, Transaction transaction) async {
    if (transaction.type == TransactionType.expense && transaction.amount > totalBalance) {
      return false; 
    }

    final newTransaction = Transaction(
      id: transaction.id,
      amount: transaction.amount,
      category: transaction.category,
      date: transaction.date,
      type: transaction.type,
      description: description,
    );
    _transactions.add(newTransaction);
    await _saveTransactions();
    notifyListeners();
    return true;
  }


  Future<void> addToGoal(String goalId, double amount) async {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      final oldGoal = _goals[goalIndex];
      final newAmount = oldGoal.currentAmount + amount;

      if (newAmount >= oldGoal.targetAmount) {
        final completedGoal = oldGoal.copyWith(currentAmount: newAmount);
        _completedGoals.add(completedGoal);
        _goals.removeAt(goalIndex);
        await _saveCompletedGoals();
        await _saveGoals();
      } else {
        _goals[goalIndex] = oldGoal.copyWith(currentAmount: newAmount);
        await _saveGoals();
      }

      await addTransaction(
        'Meta: \${oldGoal.name}',
        Transaction(
          id: DateTime.now().toString(),
          amount: amount,
          category: 'Meta: \${oldGoal.name}',
          date: DateTime.now(),
          type: TransactionType.income,
          description: 'goal',
        ),
      );

      notifyListeners();
    }
  }

  Future<void> addNewGoal(String name, double targetAmount) async {
    final newGoal = Goal(
      id: DateTime.now().toString(),
      name: name,
      currentAmount: 0,
      targetAmount: targetAmount,
      frequency: 'Personalizado',
    );
    _goals.add(newGoal);
    await _saveGoals();
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      await _saveGoals();
      notifyListeners();
    }
  }

  Map<String, double> getMonthlySavingsPercentages() {
  final Map<String, double> monthlySavings = {};

  for (var transaction in _transactions) {
    if (transaction.description == 'goal') continue;
    final monthYear = "${transaction.date.month.toString().padLeft(2, '0')}-${transaction.date.year}";

    if (!monthlySavings.containsKey(monthYear)) {
      monthlySavings[monthYear] = 0.0;
    }
  }

  monthlySavings.forEach((monthYear, _) {
    double ingresos = 0;
    double egresos = 0;

    for (var transaction in _transactions) {
      if (transaction.description == 'goal') continue;
      final txMonthYear = "${transaction.date.month.toString().padLeft(2, '0')}-${transaction.date.year}";

      if (txMonthYear == monthYear) {
        if (transaction.type == TransactionType.income) {
          ingresos += transaction.amount;
        } else {
          egresos += transaction.amount;
        }
      }
    }

    final ahorro = ingresos - egresos;
    final porcentaje = ingresos > 0 ? (ahorro / ingresos) * 100 : 0.0;
    monthlySavings[monthYear] = porcentaje;
  });

  return monthlySavings;
}


  String getRecommendationForMonth(String monthYear) {
    final monthlyData = getMonthlySavingsPercentages();
    if (!monthlyData.containsKey(monthYear)) return "No hay datos para este mes.";
    final savingsPercent = monthlyData[monthYear]!;
    if (savingsPercent < 10) {
      return "Estás ahorrando menos del 10% de tus ingresos. Revisa tus gastos.";
    } else if (savingsPercent < 20) {
      return "Buen trabajo. Vas por buen camino, ¡pero puedes mejorar!";
    } else {
      return "¡Excelente! Estás ahorrando más del 20%.";
    }
  }

  String getMascotMessage() {
    final now = DateTime.now();
    final currentMonthYear = "\${now.month.toString().padLeft(2, '0')}-\${now.year}";
    final savings = getMonthlySavingsPercentages();
    final savingPercent = savings[currentMonthYear] ?? 0;

    if (savingPercent >= 30) {
      return "🌟 ¡Increíble! Estás ahorrando un gran porcentaje este mes. ¡Sigue así!";
    } else if (savingPercent >= 15) {
      return "😊 Buen trabajo. Vas por un buen camino, ¡no aflojes!";
    } else if (savingPercent >= 1) {
      return "⚠️ Puedes mejorar tu ahorro este mes. Revisa tus gastos.";
    } else {
      return "😟 Este mes no has ahorrado. ¡No te preocupes, el próximo puedes empezar mejor!";
    }
  }

  int get totalGoodSavingsMonths {
    final savings = getMonthlySavingsPercentages();
    return savings.values.where((percent) => percent >= 10).length;
  }

  int get totalGoalsCompleted => _completedGoals.length;

  int get consistentMonths {
    final Map<String, double> savings = getMonthlySavingsPercentages();
    return savings.values.where((percent) => percent > 0 && percent <= 100).length;
  }
}
