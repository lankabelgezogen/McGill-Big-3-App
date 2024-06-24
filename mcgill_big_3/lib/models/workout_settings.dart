import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSettings {
  int exerciseDuration;
  int pauseDuration;

  WorkoutSettings({
    this.exerciseDuration = 10,
    this.pauseDuration = 5,
  });

  factory WorkoutSettings.fromPrefs(SharedPreferences prefs) {
    return WorkoutSettings(
      exerciseDuration: prefs.getInt('exerciseDuration') ?? 10,
      pauseDuration: prefs.getInt('pauseDuration') ?? 5,
    );
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setInt('exerciseDuration', exerciseDuration);
    await prefs.setInt('pauseDuration', pauseDuration);
  }
}
