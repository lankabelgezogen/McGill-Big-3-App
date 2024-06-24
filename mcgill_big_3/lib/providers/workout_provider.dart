import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mcgill_big_3/models/workout_settings.dart';
import 'package:mcgill_big_3/models/workout_history.dart';

class WorkoutProvider with ChangeNotifier {
  WorkoutSettings _settings = WorkoutSettings();
  WorkoutHistory _history = WorkoutHistory();

  WorkoutSettings get settings => _settings;
  WorkoutHistory get history => _history;

  WorkoutProvider() {
    _loadSettings();
    _loadHistory();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _settings = WorkoutSettings.fromPrefs(prefs);
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = WorkoutHistory.fromPrefs(prefs);
    notifyListeners();
  }

  Future<void> updateSettings(WorkoutSettings newSettings) async {
    _settings = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await _settings.saveToPrefs(prefs);
    notifyListeners();
  }

  Future<void> addWorkoutCompletion(DateTime date) async {
    _history.addCompletion(date);
    final prefs = await SharedPreferences.getInstance();
    await _history.saveToPrefs(prefs);
    notifyListeners();
  }

  Future<void> removeWorkoutCompletion(DateTime date) async {
    _history.removeCompletion(date);
    final prefs = await SharedPreferences.getInstance();
    await _history.saveToPrefs(prefs);
    notifyListeners();
  }
}
