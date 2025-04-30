import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:provider/provider.dart';
import 'package:spendee/data/questions_data.dart';
import 'package:spendee/providers/learning_provider.dart';

class ExerciseQuestionScreen extends StatefulWidget {
  final LevelData levelData;

  const ExerciseQuestionScreen({Key? key, required this.levelData}) : super(key: key);

  @override
  _ExerciseQuestionScreenState createState() => _ExerciseQuestionScreenState();
}

class _ExerciseQuestionScreenState extends State<ExerciseQuestionScreen> {
  int currentStep = 0;
  int points = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.levelData.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (currentStep < 6) {
      bool isExerciseStep = currentStep % 2 == 0;
      int index = currentStep ~/ 2;

      if (isExerciseStep) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ejercicio ${index + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              widget.levelData.exercises[index],
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep++;
                });
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      } else {
        final question = widget.levelData.questions[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pregunta ${index + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              question.question,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ...List.generate(question.options.length, (optIndex) {
              return ElevatedButton(
                onPressed: () => _handleAnswer(optIndex, question.correctOptionIndex),
                child: Text(question.options[optIndex]),
              );
            }),
          ],
        );
      }
    } else {
      return _buildResultView();
    }
  }

  void _handleAnswer(int selectedIndex, int correctIndex) {
    if (selectedIndex == correctIndex) {
      points += widget.levelData.pointsPerCorrect;
    }
    setState(() {
      currentStep++;
    });
  }

  Widget _buildResultView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¡Nivel completado!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            'Puntos obtenidos: $points',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              final box = await Hive.openBox('learningBox');

              await box.put('level_${widget.levelData.title}_completed', true);
              await box.put('level_${widget.levelData.title}_points', points);

              Provider.of<LearningProvider>(context, listen: false)
                  .completeLevel(levelsData.indexOf(widget.levelData));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Felicidades! Completaste este nivel 🎉'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );

              Navigator.pop(context);
            },
            child: const Text('Volver al Aprendizaje'),
          )
        ],
      ),
    );
  }
}
