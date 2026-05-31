import 'package:flutter/material.dart';
import '../models/magic_game.dart';

class GameProvider extends ChangeNotifier {
  final MagicGame _game = MagicGame();
  int _currentStep = 0;
  bool _showConfetti = false;

  int get currentStep => _currentStep;
  bool get showConfetti => _showConfetti;
  MagicGame get game => _game;
  String get magicSymbol => _game.magicSymbol;
  Map<int, String> get symbolMap => _game.symbolMap;
  int get playCount => _game.playCount;
  String get lastSymbol => _game.lastSymbol;

  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  void revealSymbol() {
    _game.recordReveal();
    _currentStep = 3;
    _showConfetti = true;
    notifyListeners();
  }

  void resetGame() {
    _game.generateSymbols();
    _currentStep = 0;
    _showConfetti = false;
    notifyListeners();
  }
}
