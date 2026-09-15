import 'package:flutter/material.dart';
import '../models/magic_game.dart';

/// Flow state for the 4-step ritual.
///
/// Steps: 0 intro · 1 instructions · 2 symbols · 3 reveal.
/// Back navigation and jump-to are explicit so the app bar back
/// button and progress rail always behave predictably.
class GameProvider extends ChangeNotifier {
  final MagicGame _game = MagicGame();
  int _currentStep = 0;
  bool _showConfetti = false;

  static const List<String> stepLabels = [
    'Imagine',
    'Calculate',
    'Memorize',
    'Reveal',
  ];

  int get currentStep => _currentStep;
  bool get showConfetti => _showConfetti;
  bool get canGoBack => _currentStep > 0 && _currentStep < 3;
  MagicGame get game => _game;
  String get magicSymbol => _game.magicSymbol;
  Map<int, String> get symbolMap => _game.symbolMap;
  int get playCount => _game.playCount;
  String get lastSymbol => _game.lastSymbol;

  void nextStep() {
    if (_currentStep >= 3) return;
    _currentStep++;
    notifyListeners();
  }

  void goBack() {
    if (!canGoBack) return;
    _currentStep--;
    notifyListeners();
  }

  void goTo(int step) {
    final clamped = step.clamp(0, 3);
    if (clamped == _currentStep) return;
    _currentStep = clamped;
    notifyListeners();
  }

  void revealSymbol() {
    _game.recordReveal();
    _currentStep = 3;
    _showConfetti = true;
    notifyListeners();
  }

  void hideConfetti() {
    _showConfetti = false;
    notifyListeners();
  }

  void resetGame() {
    _game.generateSymbols();
    _currentStep = 0;
    _showConfetti = false;
    notifyListeners();
  }
}
