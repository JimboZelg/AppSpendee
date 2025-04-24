import 'package:hive_ce/hive.dart';
import 'goal.dart';

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 2; // Usa un ID diferente a Transaction

  @override
  Goal read(BinaryReader reader) {
    return Goal(
      id: reader.readString(),
      name: reader.readString(),
      currentAmount: reader.readDouble(),
      targetAmount: reader.readDouble(),
      frequency: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.currentAmount);
    writer.writeDouble(obj.targetAmount);
    writer.writeString(obj.frequency);
  }
}
