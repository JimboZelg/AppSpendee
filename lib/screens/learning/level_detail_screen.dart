import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/data/questions_data.dart';
import 'package:spendee/screens/learning/exercise_question_screen.dart';
import 'package:spendee/providers/learning_provider.dart';

class LevelDetailScreen extends StatelessWidget {
  final int levelId;

  const LevelDetailScreen({Key? key, required this.levelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelData = levelsData[levelId];
    final completed = Provider.of<LearningProvider>(context).levels[levelId].completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(levelData.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: completed
            ? _buildAdviceView(levelData.advice)
            : _buildExercisesView(context, levelData),
      ),
    );
  }

  Widget _buildAdviceView(String advice) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline, size: 80, color: Colors.blue),
        const SizedBox(height: 24),
        const Text(
          'Ya completaste este nivel.',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(
          advice,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        const Text(
          '¡Felicidades por tu progreso! 🎉',
          style: TextStyle(fontSize: 18, color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildExercisesView(BuildContext context, LevelData levelData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ejercicios de este nivel:',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...levelData.exercises.map((exercise) => ListTile(
              leading: const Icon(Icons.check),
              title: Text(exercise),
            )),
        const SizedBox(height: 40),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseQuestionScreen(levelData: levelData),
                ),
              );
            },
            child: const Text('Iniciar Nivel'),
          ),
        ),
      ],
    );
  }
}
