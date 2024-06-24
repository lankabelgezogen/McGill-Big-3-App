import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mcgill_big_3/providers/workout_provider.dart';
import 'package:mcgill_big_3/models/workout_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _exerciseDurationController;
  late TextEditingController _pauseDurationController;

  @override
  void initState() {
    super.initState();
    final settings =
        Provider.of<WorkoutProvider>(context, listen: false).settings;
    _exerciseDurationController =
        TextEditingController(text: settings.exerciseDuration.toString());
    _pauseDurationController =
        TextEditingController(text: settings.pauseDuration.toString());
  }

  @override
  void dispose() {
    _exerciseDurationController.dispose();
    _pauseDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _exerciseDurationController,
              decoration: const InputDecoration(
                  labelText: 'Exercise Duration (seconds)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pauseDurationController,
              decoration:
                  const InputDecoration(labelText: 'Pause Duration (seconds)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final newSettings = WorkoutSettings(
                  exerciseDuration: int.parse(_exerciseDurationController.text),
                  pauseDuration: int.parse(_pauseDurationController.text),
                );
                Provider.of<WorkoutProvider>(context, listen: false)
                    .updateSettings(newSettings);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved')),
                );
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
