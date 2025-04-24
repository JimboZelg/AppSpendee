import 'package:hive_ce/hive.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double currentAmount;
  
  @HiveField(3)
  final double targetAmount;
  
  @HiveField(4)
  final String frequency;
  
  @HiveField(5)
  final double progress;

  Goal({
    required this.id,
    required this.name,
    required this.currentAmount,
    required this.targetAmount,
    required this.frequency,
  }) : progress = (currentAmount / targetAmount * 100).clamp(0, 100);

  Goal copyWith({
    String? id,
    String? name,
    double? currentAmount,
    double? targetAmount,
    String? frequency,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      currentAmount: currentAmount ?? this.currentAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      frequency: frequency ?? this.frequency,
    );
  }
}
