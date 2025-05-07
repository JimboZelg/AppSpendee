import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:spendee/models/level.dart';

class LearningProvider with ChangeNotifier {
  List<Level> _levels = List.generate(
    10,
    (index) => Level(id: index, title: 'Nivel ${index + 1}', completed: false),
  );

  List<Level> get levels => _levels;

  Future<void> loadProgress() async {
    final box = await Hive.openBox('learningBox');
    for (var level in _levels) {
      level.completed = box.get('level_${level.id}_completed', defaultValue: false);
    }
    notifyListeners();
  }

  Future<void> completeLevel(int id) async {
    final box = await Hive.openBox('learningBox');
    _levels[id].completed = true;
    await box.put('level_${id}_completed', true);
    notifyListeners();
  }

  Future<void> resetLearningProgress() async {
    final box = await Hive.openBox('learningBox');

    // Marcar todos los niveles como no completados
    for (var level in _levels) {
      level.completed = false;
    }

    await box.clear(); // Borra toda la caja Hive relacionada
    notifyListeners();
  }
}
