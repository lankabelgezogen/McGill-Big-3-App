import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mcgill_big_3/providers/workout_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('McGill Big 3'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          final today = DateTime.now();
          final isCompletedToday = workoutProvider.history.isCompleted(today);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final date = today.subtract(Duration(days: index));
                    final isCompleted =
                        workoutProvider.history.isCompleted(date);
                    return ListTile(
                      title: Text(DateFormat('EEEE, MMMM d').format(date)),
                      trailing: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isCompleted ? Colors.green : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: isCompletedToday
                      ? () {
                          workoutProvider.removeWorkoutCompletion(today);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Workout marked as incomplete')),
                          );
                        }
                      : () => Navigator.pushNamed(context, '/timer'),
                  child: Text(isCompletedToday
                      ? 'Redo Today\'s Workout'
                      : 'Start Workout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
