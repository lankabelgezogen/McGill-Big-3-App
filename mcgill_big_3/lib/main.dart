import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 10;
  Timer? _timer;
  final player = AudioPlayer();

  final List<String> _exerciseSequence = const [
    'McGill Curl-Up: Left Side',
    'Pause',
    'McGill Curl-Up: Left Side',
    'Pause',
    'McGill Curl-Up: Left Side',
    'Pause',
    'Switch Sides',
    'McGill Curl-Up: Right Side',
    'Pause',
    'McGill Curl-Up: Right Side',
    'Pause',
    'McGill Curl-Up: Right Side',
    'Pause',
    'Side Plank: Left Side',
    'Pause',
    'Side Plank: Left Side',
    'Pause',
    'Side Plank: Left Side',
    'Pause',
    'Switch Sides',
    'Side Plank: Right Side',
    'Pause',
    'Side Plank: Right Side',
    'Pause',
    'Side Plank: Right Side',
    'Pause',
    'Bird-Dog: Left Side',
    'Pause',
    'Bird-Dog: Left Side',
    'Pause',
    'Bird-Dog: Left Side',
    'Pause',
    'Switch Sides',
    'Bird-Dog: Right Side',
    'Pause',
    'Bird-Dog: Right Side',
    'Pause',
    'Bird-Dog: Right Side',
    'Pause',
  ];

  int _currentStep = 0;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _playAnnouncement();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          if (_seconds <= 3) {
            _playBeep();
          }
          _seconds--;
        } else {
          if (_currentStep < _exerciseSequence.length - 1) {
            _currentStep++;
            _playAnnouncement();
            _seconds = 10;
          } else {
            timer.cancel();
            _showCompletionDialog();
          }
        }
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < _exerciseSequence.length - 1) {
        _currentStep++;
        _seconds = 10;
        _playAnnouncement();
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
        _seconds = 10;
        _playAnnouncement();
      }
    });
  }

  Future<void> _playAnnouncement() async {
    if (_currentStep == 0) {
      await player.play(AssetSource("announcement_mcgill_curl_up.mp3"));
    } else if (_exerciseSequence[_currentStep] == 'Switch Sides') {
      await player.play(AssetSource("announcement_switch_sides.mp3"));
    } else if (_exerciseSequence[_currentStep] == 'Side Plank: Left Side' ||
        _exerciseSequence[_currentStep] == 'Side Plank: Right Side') {
      if (_exerciseSequence[_currentStep - 1] == 'Pause') {
        await player.play(AssetSource("announcement_side_plank.mp3"));
      }
    } else if (_exerciseSequence[_currentStep] == 'Bird-Dog: Left Side' ||
        _exerciseSequence[_currentStep] == 'Bird-Dog: Right Side') {
      if (_exerciseSequence[_currentStep - 1] == 'Pause') {
        await player.play(AssetSource("announcement_bird_dog.mp3"));
      }
    }
  }

  Future<void> _playBeep() async {
    await player.play(AssetSource("beep.mp3"));
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exercise Completed'),
          content: const Text('You have completed all exercises.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentStep = 0;
                  _seconds = 10;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('McGill Big 3 Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _exerciseSequence[_currentStep],
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
              value: (_currentStep + 1) / _exerciseSequence.length,
              minHeight: 10,
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _previousStep,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
