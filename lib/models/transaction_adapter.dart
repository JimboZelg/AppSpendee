import 'package:hive_ce/hive.dart';
import 'transaction.dart';
import 'transaction_type.dart';

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      id: reader.readString(),
      amount: reader.readDouble(),
      category: reader.readString(),
      date: DateTime.parse(reader.readString()),
      type: TransactionType.values[reader.readInt()],
      description: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.writeString(obj.id);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.category);
    writer.writeString(obj.date.toIso8601String());
    writer.writeInt(obj.type.index);
    writer.writeString(obj.description);
  }
}
