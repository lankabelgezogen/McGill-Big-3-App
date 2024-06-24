import 'package:shared_preferences/shared_preferences.dart';

class WorkoutHistory {
  Set<String> completedDates;

  WorkoutHistory({Set<String>? completedDates})
      : completedDates = completedDates ?? {};

  factory WorkoutHistory.fromPrefs(SharedPreferences prefs) {
    final dates = prefs.getStringList('completedDates') ?? [];
    return WorkoutHistory(completedDates: dates.toSet());
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setStringList('completedDates', completedDates.toList());
  }

  void addCompletion(DateTime date) {
    completedDates.add(date.toIso8601String().split('T')[0]);
  }

  void removeCompletion(DateTime date) {
    completedDates.remove(date.toIso8601String().split('T')[0]);
  }

  bool isCompleted(DateTime date) {
    return completedDates.contains(date.toIso8601String().split('T')[0]);
  }
}
