import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mcgill_big_3/providers/workout_provider.dart';
import 'package:mcgill_big_3/widgets/exercise_timer.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return ExerciseTimer(
            exerciseDuration: workoutProvider.settings.exerciseDuration,
            pauseDuration: workoutProvider.settings.pauseDuration,
            onComplete: () {
              workoutProvider.addWorkoutCompletion(DateTime.now());
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
