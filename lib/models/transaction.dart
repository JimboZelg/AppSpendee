import 'package:hive_ce/hive.dart';
import 'transaction_type.dart';

class Transaction {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String description;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.description,
  });

  bool get isValid => amount >= 0 && description.isNotEmpty && category.isNotEmpty;
}
