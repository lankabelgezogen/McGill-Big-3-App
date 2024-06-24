import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock/wakelock.dart';

class ExerciseTimer extends StatefulWidget {
  final int exerciseDuration;
  final int pauseDuration;
  final VoidCallback onComplete;

  const ExerciseTimer({
    super.key,
    required this.exerciseDuration,
    required this.pauseDuration,
    required this.onComplete,
  });

  @override
  _ExerciseTimerState createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late int _seconds;
  Timer? _timer;
  final player = AudioPlayer();
  int _currentStep = -1; // Start at -1 for preparation time
  bool _isPause = false;
  bool _isPreparation = true;

  final List<String> _exerciseSequence = const [
    'McGill Curl-Up: Left Side',
    'McGill Curl-Up: Left Side',
    'McGill Curl-Up: Left Side',
    'McGill Curl-Up: Right Side',
    'McGill Curl-Up: Right Side',
    'McGill Curl-Up: Right Side',
    'Side Plank: Left Side',
    'Side Plank: Left Side',
    'Side Plank: Left Side',
    'Side Plank: Right Side',
    'Side Plank: Right Side',
    'Side Plank: Right Side',
    'Bird-Dog: Left Side',
    'Bird-Dog: Left Side',
    'Bird-Dog: Left Side',
    'Bird-Dog: Right Side',
    'Bird-Dog: Right Side',
    'Bird-Dog: Right Side',
  ];

  @override
  void initState() {
    super.initState();
    _seconds = 5; // Start with 5 seconds preparation time
    Wakelock.enable();
  }

  @override
  void dispose() {
    _timer?.cancel();
    Wakelock.disable();
    player.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          if (_seconds <= 1) {
            _playBeep();
          }
          _seconds--;
        } else {
          if (_isPreparation) {
            _isPreparation = false;
            _currentStep++;
            _seconds = widget.exerciseDuration;
            _playAnnouncement();
          } else if (_currentStep < _exerciseSequence.length - 1) {
            _currentStep++;
            _isPause = !_isPause;
            _seconds =
                _isPause ? widget.pauseDuration : widget.exerciseDuration;
            _playAnnouncement();
          } else {
            timer.cancel();
            widget.onComplete();
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _playBeep() async {
    await player.play(AssetSource("beep.mp3"));
  }

  Future<void> _playAnnouncement() async {
    if (_isPreparation) {
      await player.play(AssetSource("beep.mp3"));
    } else if (!_isPause) {
      if (_currentStep % 3 == 0) {
        if (_currentStep < 6) {
          await player.play(AssetSource("announcement_mcgill_curl_up.mp3"));
        } else if (_currentStep < 12) {
          await player.play(AssetSource("announcement_side_plank.mp3"));
        } else {
          await player.play(AssetSource("announcement_bird_dog.mp3"));
        }
      }
      if (_currentStep % 6 == 3) {
        await player.play(AssetSource("announcement_switch_sides.mp3"));
      }
    }
  }

  String _getNextExercise() {
    if (_currentStep < _exerciseSequence.length - 1) {
      return _exerciseSequence[_currentStep + 1];
    } else {
      return 'Workout Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _isPreparation
                ? 'Prepare to start'
                : (_isPause ? 'Pause' : _exerciseSequence[_currentStep]),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            '$_seconds',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: (_currentStep + 1) / (_exerciseSequence.length + 1),
            minHeight: 10,
          ),
          const SizedBox(height: 20),
          Text(
            'Next up: ${_getNextExercise()}',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _startTimer,
                child: const Text('Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _stopTimer,
                child: const Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
