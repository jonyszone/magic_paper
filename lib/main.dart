import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MagicPaperApp());
}

class MagicPaperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Paper Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MagicPaperScreen(),
    );
  }
}

class MagicPaperScreen extends StatefulWidget {
  @override
  _MagicPaperScreenState createState() => _MagicPaperScreenState();
}

class _MagicPaperScreenState extends State<MagicPaperScreen> {
  final TextEditingController _numberController = TextEditingController();
  String _message = 'Think of a two-digit number...';
  bool _showSymbols = false;
  bool _showFinalSymbol = false;
  String _magicSymbol = '';
  List<int> _multiplesOf9 = List.generate(9, (index) => (index + 1) * 9);
  List<String> _symbols = [
    '🔮', '✨', '🎩', '🔢', '🃏', '🔻', '🌟', '🧩', '💎', '🎲', '🍀', '⚡',
    '🌙', '🌍', '🔥', '🦄', '🐉', '🎴', '🔷', '⚽', '🎻', '🔔', '🎯'
  ];
  Map<int, String> _symbolMap = {};
  String _finalMessage = '';

  void _calculateMagicNumber() {
    setState(() {
      final int? number = int.tryParse(_numberController.text);
      if (number == null || number < 10 || number > 99) {
        _message = 'Please enter a valid two-digit number!';
        return;
      }

      int digitSum =
          number.toString().split('').map(int.parse).reduce((a, b) => a + b);
      int magicNumber = number - digitSum;

      _magicSymbol = _symbols[Random().nextInt(_symbols.length)];

      _symbolMap.clear();
      for (int i = 1; i < 100; i++) {
        if (_multiplesOf9.contains(i)) {
          _symbolMap[i] = _magicSymbol;
        } else {
          _symbolMap[i] = _symbols[Random().nextInt(_symbols.length)];
        }
      }

      _showSymbols = true;
    });
  }

  void _goToFinalScreen() {
    setState(() {
      _showSymbols = false;
      _showFinalSymbol = true;
      _finalMessage = 'Your magic symbol is:';
    });
  }

  void _resetGame() {
    setState(() {
      _message = 'Think of a two-digit number...';
      _showSymbols = false;
      _showFinalSymbol = false;
      _numberController.clear();
      _symbolMap.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magic Paper Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Instructions: Think of a two-digit number. Add both digits together and subtract the sum from your original number. Remember the final number and its corresponding symbol.\n\n'
                'Example:\n'
                '1. Think of a two-digit number, e.g., 42.\n'
                '2. Add the digits: 4 + 2 = 6.\n'
                '3. Subtract the sum from the original number: 42 - 6 = 36.\n'
                '4. Remember the final number (36) and its corresponding symbol.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (!_showSymbols && !_showFinalSymbol)
                Column(
                  children: [
                    TextField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter your number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculateMagicNumber,
                      child: Text('See the Symbols!'),
                    ),
                  ],
                ),
              if (_showSymbols)
                Column(
                  children: [
                    Text(
                      'Memorize the symbol for your calculated number:',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: List.generate(99, (index) {
                        return Text(
                          '${index + 1}: ${_symbolMap[index + 1] ?? ''}',
                          style: TextStyle(fontSize: 18),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _goToFinalScreen,
                      child: Text('Reveal Your Symbol!'),
                    ),
                  ],
                ),
              if (_showFinalSymbol)
                Column(
                  children: [
                    Text(
                      _finalMessage,
                      style: TextStyle(fontSize: 24, color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(_magicSymbol, style: TextStyle(fontSize: 100)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _resetGame,
                      child: Text('Play Again'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
