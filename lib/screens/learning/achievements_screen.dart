import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:spendee/data/questions_data.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  Box? learningBox;

  @override
  void initState() {
    super.initState();
    _loadBox();
  }

  Future<void> _loadBox() async {
    learningBox = await Hive.openBox('learningBox');
    setState(() {});
  }

  bool isLevelCompleted(String title) {
    if (learningBox == null) return false;
    return learningBox!.get('level_${title}_completed', defaultValue: false);
  }

  int completedAchievementsCount() {
    if (learningBox == null) return 0;
    return levelsData.where((level) => isLevelCompleted(level.title)).length;
  }

  @override
  Widget build(BuildContext context) {
    if (learningBox == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    int totalCompleted = completedAchievementsCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logros'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Logros: $totalCompleted de ${levelsData.length} completados',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: levelsData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final level = levelsData[index];
                final completed = isLevelCompleted(level.title);

                return Container(
                  decoration: BoxDecoration(
                    color: completed ? Colors.amber : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        completed ? Icons.emoji_events : Icons.lock_outline,
                        size: 48,
                        color: completed ? Colors.white : Colors.black54,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          level.title.replaceAll('Nivel ', 'N°'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: completed ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
