import 'dart:math';

class MagicSymbol {
  final int number;
  final String symbol;
  final bool isMultipleOf9;

  const MagicSymbol({
    required this.number,
    required this.symbol,
    required this.isMultipleOf9,
  });
}

class MagicGame {
  static const List<int> multiplesOf9 = [9, 18, 27, 36, 45, 54, 63, 72, 81];
  static const List<String> symbols = [
    '🔮', '✨', '🎩', '🌟', '💎', '🌙', '🔥', '🦋', '⚡',
    '🍀', '🎯', '💜', '🌀', '⭐', '🌈', '🎪', '💠', '🔮'
  ];

  String magicSymbol = '';
  Map<int, String> symbolMap = {};
  int playCount = 0;
  String lastSymbol = '';

  void generateSymbols() {
    final random = Random();
    magicSymbol = symbols[random.nextInt(symbols.length)];
    symbolMap.clear();
    
    for (int i = 1; i < 100; i++) {
      symbolMap[i] = multiplesOf9.contains(i) 
          ? magicSymbol 
          : symbols[random.nextInt(symbols.length)];
    }
  }

  void recordReveal() {
    lastSymbol = magicSymbol;
    playCount++;
  }

  bool isMultipleOf9Number(int number) => multiplesOf9.contains(number);
}
