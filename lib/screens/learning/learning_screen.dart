import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:provider/provider.dart';
import 'package:spendee/providers/learning_provider.dart';
import 'package:spendee/screens/learning/level_detail_screen.dart';
import 'package:spendee/screens/learning/achievements_screen.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late Box learningBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    learningBox = await Hive.openBox('learningBox');
    setState(() {});
  }

  bool isLevelCompleted(int index, List levels) {
    return levels[index].completed;
  }

  bool isLevelAvailable(int index, List levels) {
    if (index == 0) return true;
    return levels[index - 1].completed;
  }

  @override
  Widget build(BuildContext context) {
    final levels = Provider.of<LearningProvider>(context).levels;

    if (!Hive.isBoxOpen('learningBox')) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprendizaje'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.emoji_events),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AchievementsScreen()),
          );
        },
      ),
      body: ListView.builder(
        itemCount: levels.length,
        itemBuilder: (ctx, i) {
          final completed = isLevelCompleted(i, levels);
          final available = isLevelAvailable(i, levels);

          return ListTile(
            leading: completed
                ? const Icon(Icons.check_circle, color: Colors.green)
                : available
                    ? const Icon(Icons.lock_open, color: Colors.blue)
                    : const Icon(Icons.lock, color: Colors.grey),
            title: Text(levels[i].title),
            trailing: const Icon(Icons.arrow_forward_ios),
            enabled: available,
            onTap: available
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LevelDetailScreen(levelId: levels[i].id),
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}
