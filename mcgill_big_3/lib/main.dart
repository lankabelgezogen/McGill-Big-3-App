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
  int _preExerciseCountdown = 5;
  Timer? _timer;
  final player = AudioPlayer();
  bool _mcgillCurlUpAnnounced = false;
  bool _sidePlankAnnounced = false;
  bool _birdDogAnnounced = false;
  bool _preExerciseCountdownActive = true;

  final List<String> _exerciseSequence = const [
    'McGill Curl-Up: Left Side',
    'Pause',
    'McGill Curl-Up: Left Side',
    'Pause',
    'McGill Curl-Up: Left Side',
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
    'Switch Sides',
    'Bird-Dog: Right Side',
    'Pause',
    'Bird-Dog: Right Side',
    'Pause',
    'Bird-Dog: Right Side'
  ];

  int _currentStep = 0;

  void _startPreExerciseCountdown() {
    setState(() {
      _preExerciseCountdownActive = true;
      _preExerciseCountdown = 5;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_preExerciseCountdown > 0) {
          _preExerciseCountdown--;
        } else {
          _preExerciseCountdownActive = false;
          timer.cancel();
          _startTimer();
        }
      });
    });
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _playAnnouncement();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          if (_seconds <= 1) {
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
    if (_currentStep == 0 && !_mcgillCurlUpAnnounced) {
      await player.play(AssetSource("announcement_mcgill_curl_up.mp3"));
      _mcgillCurlUpAnnounced = true;
    } else if (_exerciseSequence[_currentStep] == 'Switch Sides') {
      await player.play(AssetSource("announcement_switch_sides.mp3"));
    } else if (_exerciseSequence[_currentStep].startsWith('Side Plank') &&
        !_sidePlankAnnounced) {
      if (_exerciseSequence[_currentStep - 1] == 'Pause') {
        await player.play(AssetSource("announcement_side_plank.mp3"));
        _sidePlankAnnounced = true;
      }
    } else if (_exerciseSequence[_currentStep].startsWith('Bird-Dog') &&
        !_birdDogAnnounced) {
      if (_exerciseSequence[_currentStep - 1] == 'Pause') {
        await player.play(AssetSource("announcement_bird_dog.mp3"));
        _birdDogAnnounced = true;
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
                  _mcgillCurlUpAnnounced = false;
                  _sidePlankAnnounced = false;
                  _birdDogAnnounced = false;
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
        title: const Text('McGill Big 3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_preExerciseCountdownActive)
              Text(
                'Starting in $_preExerciseCountdown seconds',
                style: const TextStyle(fontSize: 24),
              )
            else
              Column(
                children: [
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
                  Text(
                    'Next: ${_currentStep < _exerciseSequence.length - 1 ? _exerciseSequence[_currentStep + 1] : 'Completed'}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (!_preExerciseCountdownActive)
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
            if (_preExerciseCountdownActive)
              ElevatedButton(
                onPressed: _startPreExerciseCountdown,
                child: const Text('Start Workout'),
              ),
            const SizedBox(height: 20),
            if (!_preExerciseCountdownActive)
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
