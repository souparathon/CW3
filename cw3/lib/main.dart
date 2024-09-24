import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({Key? key}) : super(key: key);

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Juandissmo Magnifico";
  int happinessLevel = 50;
  int hungerLevel = 50;
  final String _currentImage = 'assets/cat.png';
  Color _petColor = Colors.yellow;
  String _petMood = "Neutral";
  Timer? _hungerTimer;
  Timer? _winTimer;
  bool _isWinTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 1).clamp(0, 100);
        _updatePetColorAndMood();
        _checkWinCondition();
        _checkLossCondition();
      });
    });
  }

  void _checkWinCondition() {
    if (happinessLevel > 80) {
      if (!_isWinTimerRunning) {
        _isWinTimerRunning = true;
        _winTimer = Timer(const Duration(seconds: 10), () {
          if (happinessLevel > 80) {
            _showWinMessage();
          }
        });
      }
    } else {
      _isWinTimerRunning = false;
      _winTimer?.cancel();
    }
  }

  void _checkLossCondition() {
    if (hungerLevel == 100 && happinessLevel <= 10) {
      _showGameOverMessage();
    }
  }

  void _showWinMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("You Win!"),
          content: const Text("Your pet is very happy!"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGameOverMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: const Text("Your pet is too hungry and unhappy."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetColorAndMood();
      _checkWinCondition();
      _checkLossCondition();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetColorAndMood();
      _checkWinCondition();
      _checkLossCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  void _updatePetColorAndMood() {
    if (happinessLevel > 70) {
      _petColor = Colors.green;
      _petMood = "Bro feeling great rn";
    } else if (happinessLevel >= 30) {
      _petColor = Colors.yellow;
      _petMood = "He ight";
    } else {
      _petColor = Colors.red;
      _petMood = "He is plotting your death";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Name: $petName',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Image.asset(
              _currentImage,
              color: _petColor,
              colorBlendMode: BlendMode.color,
            ),
            Text(
              'Happiness Level: $happinessLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'Mood: $_petMood',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: const Text('Play with Your Pet'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: const Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
