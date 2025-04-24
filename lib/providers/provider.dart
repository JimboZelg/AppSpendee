import 'package:flutter/foundation.dart';
import 'package:spendee/models/transaction_type.dart';
import '../models/transaction.dart';
import '../models/goal.dart';

class WalletProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Goal> _goals = [
    Goal(
      id: '1',
      name: 'Vacaciones',
      currentAmount: 10500,
      targetAmount: 15000,
      frequency: 'Mensual',
    ),
    Goal(
      id: '2',
      name: 'Titulación',
      currentAmount: 1000,
      targetAmount: 4000,
      frequency: 'Semanal',
    ),
    Goal(
      id: '3',
      name: 'GTA VI',
      currentAmount: 1260,
      targetAmount: 1400,
      frequency: 'Semanal',
    ),
  ];

  List<Transaction> get transactions => _transactions;
  List<Goal> get goals => _goals;

  double get totalBalance {
  return _transactions.fold(0, (sum, transaction) {
    return sum + (transaction.type == TransactionType.expense ? -transaction.amount : transaction.amount);
  });
}

double get totalIncome {
  return _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, transaction) => sum + transaction.amount);
}

double get totalExpenses {
  return _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, transaction) => sum + transaction.amount);
}


  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void updateGoal(Goal goal) {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }
}
