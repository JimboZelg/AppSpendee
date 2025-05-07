import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/goal.dart';

enum MascotEvent {
  none,
  happyIncome,
  warningExpense,
}

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

  String mascotMood = "normal";
  int _consecutiveExpenses = 0;

  WalletProvider() {
    _initHive();
  }

  bool isMascotHappy = true; 
  int consecutiveExpenses = 0;

  Future<void> _initHive() async {
    try {
      _transactionsBox = await Hive.openBox<Transaction>(transactionsBoxName);
      _goalsBox = await Hive.openBox<Goal>(goalsBoxName);
      _completedGoalsBox = await Hive.openBox<Goal>(completedGoalsBoxName);
      await loadData();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
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
      debugPrint('Error loading data: $e');
    }
  }

  Future<void> _saveTransactions() async {
    try {
      await _transactionsBox.clear();
      await _transactionsBox.addAll(_transactions);
    } catch (e) {
      debugPrint('Error saving transactions: $e');
    }
  }

  Future<void> _saveGoals() async {
    try {
      await _goalsBox.clear();
      await _goalsBox.addAll(_goals);
    } catch (e) {
      debugPrint('Error saving goals: $e');
    }
  }

  Future<void> _saveCompletedGoals() async {
    try {
      await _completedGoalsBox.clear();
      await _completedGoalsBox.addAll(_completedGoals);
    } catch (e) {
      debugPrint('Error saving completed goals: $e');
    }
  }

  List<Transaction> get transactions => _transactions;
  List<Goal> get goals => _goals;
  List<Goal> get completedGoals => _completedGoals;

  double get totalBalance {
    try {
      return _transactions.fold(0, (sum, transaction) {
        if (transaction.description != 'goal') {
          return sum + (transaction.type == TransactionType.expense ? -transaction.amount : transaction.amount);
        }
        return sum;
      });
    } catch (e) {
      debugPrint('Error calculating total balance: $e');
      return 0;
    }
  }

  double get totalIncome {
    try {
      return _transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0, (sum, transaction) => sum + transaction.amount);
    } catch (e) {
      debugPrint('Error calculating total income: $e');
      return 0;
    }
  }

  double get totalExpenses {
    try {
      return _transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0, (sum, transaction) => sum + transaction.amount);
    } catch (e) {
      debugPrint('Error calculating total expenses: $e');
      return 0;
    }
  }

  Future<MascotEvent> addTransactionWithFeedback(String description, Transaction transaction) async {
    final isHighExpense = await addTransaction(description, transaction);

    if (transaction.type == TransactionType.income) {
      return MascotEvent.happyIncome;
    } else if (transaction.type == TransactionType.expense) {
      if (_consecutiveExpenses == 0 || isHighExpense) {
        return MascotEvent.warningExpense;
      }
    }

    return MascotEvent.none;
  }

  Future<bool> addTransaction(String description, Transaction transaction) async {
    try {
      bool isHighExpense = transaction.type == TransactionType.expense && transaction.amount >= 1000;

      final isGeneral = description != 'goal' && !description.startsWith('Meta:');

      final generalBalance = _transactions
          .where((tx) => tx.description != 'goal' && !tx.description.startsWith('Meta:'))
          .fold<double>(0, (sum, tx) {
            if (tx.type == TransactionType.income) return sum + tx.amount;
            if (tx.type == TransactionType.expense) return sum - tx.amount;
            return sum;
          });

      if (transaction.type == TransactionType.expense && isGeneral && transaction.amount > generalBalance) {
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

    if (transaction.type == TransactionType.income) {
      mascotMood = "feliz";
      _consecutiveExpenses = 0;
    } else if (transaction.type == TransactionType.expense) {
      _consecutiveExpenses++;
      if (_consecutiveExpenses >= 3) {
        mascotMood = "triste";
        _consecutiveExpenses = 0;
      } else {
        mascotMood = "normal";
      }
    }

      await _saveTransactions();
      notifyListeners();
      return isHighExpense;
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      return false;
    }
  }

  Future<void> resetAllData() async {
    try {
      _transactions.clear();
      _goals.clear();
      _completedGoals.clear();

      await _transactionsBox.clear();
      await _goalsBox.clear();
      await _completedGoalsBox.clear();

      mascotMood = "normal";
      _consecutiveExpenses = 0;

      notifyListeners();
    } catch (e) {
      debugPrint('Error al borrar todos los datos: $e');
    }
  }

  Future<void> addToGoal(String goalId, double amount) async {
    try {
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
          'goal',
          Transaction(
            id: DateTime.now().toString(),
            amount: amount,
            category: "Meta: ${oldGoal.name}",
            date: DateTime.now(),
            type: TransactionType.income,
            description: 'goal',
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding to goal: $e');
    }
  }

  Future<void> addNewGoal(String name, double targetAmount) async {
    try {
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
    } catch (e) {
      debugPrint('Error adding new goal: $e');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      final index = _goals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _goals[index] = goal;
        await _saveGoals();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating goal: $e');
    }
  }

  Map<String, double> getMonthlySavingsPercentages() {
    final Map<String, double> monthlySavings = {};

    try {
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
    } catch (e) {
      debugPrint('Error calculating monthly savings: $e');
    }

    return monthlySavings;
  }

  String getRecommendationForMonth(String monthYear) {
    try {
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
    } catch (e) {
      debugPrint('Error getting recommendation: $e');
      return "No se pudo calcular la recomendación.";
    }
  }

  String getMascotMessage() {
    try {
      final now = DateTime.now();
      final currentMonthYear = "${now.month.toString().padLeft(2, '0')}-${now.year}";
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
    } catch (e) {
      debugPrint('Error getting mascot message: $e');
      return "😟 Algo salió mal al calcular tu ahorro.";
    }
  }

  int get totalGoodSavingsMonths {
    try {
      final savings = getMonthlySavingsPercentages();
      return savings.values.where((percent) => percent >= 10).length;
    } catch (e) {
      debugPrint('Error counting good months: $e');
      return 0;
    }
  }

  int get totalGoalsCompleted {
    try {
      return _completedGoals.length;
    } catch (e) {
      debugPrint('Error getting total goals completed: $e');
      return 0;
    }
  }

  int get consistentMonths {
    try {
      final savings = getMonthlySavingsPercentages();
      return savings.values.where((percent) => percent > 0 && percent <= 100).length;
    } catch (e) {
      debugPrint('Error counting consistent months: $e');
      return 0;
    }
  }

  Future<void> addScannedTransaction(double amount) async {
    try {
      final transaction = Transaction(
        id: DateTime.now().toString(),
        amount: amount,
        category: 'Ticket',
        date: DateTime.now(),
        type: TransactionType.expense,
        description: 'Gasto escaneado',
      );

      await addTransaction('ticket', transaction);
    } catch (e) {
      debugPrint('Error al agregar transacción desde ticket: $e');
    }
  }

}
