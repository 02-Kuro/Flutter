import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuro Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.yellowAccent,
        hintColor: Colors.yellowAccent,
      ),
      home: const KuroCalculator(),
    );
  }
}

class KuroCalculator extends StatefulWidget {
  const KuroCalculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KuroCalculatorState createState() => _KuroCalculatorState();
}

class _KuroCalculatorState extends State<KuroCalculator> {
  String _display = '0';
  String _operationHistory = ''; // Stocke l'opération complète
  double _num1 = 0;
  double _num2 = 0;
  String _operation = '';

  void _inputNumber(String number) {
    setState(() {
      if (_display == '0') {
        _display = number;
      } else {
        _display += number;
      }
      _operationHistory += number; // Ajoute chaque chiffre à l'historique
    });
  }

  void _inputOperation(String operation) {
    setState(() {
      _num1 = double.parse(_display);
      _operation = operation;
      _operationHistory += ' $operation '; // Ajoute l'opération à l'historique
      _display = '0';
    });
  }

  void _calculate() {
    setState(() {
      _num2 = double.parse(_display);
      double? result;
      switch (_operation) {
        case '+':
          result = _num1 + _num2;
          break;
        case '-':
          result = _num1 - _num2;
          break;
        case '*':
          result = _num1 * _num2;
          break;
        case '/':
          if (_num2 == 0) {
            _display = 'error';
          } else {
            result = _num1 / _num2;
          }
          break; // Add break statement here
        default:
          result = 0;
      }
      _display = result.toString();

      // Réinitialise l'historique une fois le calcul terminé
      _operationHistory += ' = $result'; // Add this line after setting _display
      _operation = '';
    });
  }

  void _backspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0'; // Reset to '0' if no more digits
      }
      // Remove the last character from operation history if it's not empty
      if (_operationHistory.isNotEmpty) {
        _operationHistory = _operationHistory.substring(0, _operationHistory.length - 1);
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _operationHistory = ''; // Efface l'opération complète
      _num1 = 0;
      _num2 = 0;
      _operation = '';
    });
  }

  Widget _buildButton(String label, {Color color = Colors.black, Function()? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 26, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuro Calculator')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Affiche l'historique complet de l'opération en haut
          Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: Text(
              _operationHistory,
              style: TextStyle(fontSize: 24, color: Colors.grey[500]),
            ),
          ),
          // Affiche le résultat actuel en dessous, plus grand
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          // Backspace button positioned on the right side
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _buildButton('<-', color: Colors.red, onPressed: _backspace), // Backspace button
            ],
          ),
          const SizedBox(height: 10),
          // Number buttons layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7', color: Colors.black, onPressed: () => _inputNumber('7')),
              _buildButton('8', color: Colors.black, onPressed: () => _inputNumber('8')),
              _buildButton('9', color: Colors.black, onPressed: () => _inputNumber('9')),
              _buildButton('/', color: Colors.orangeAccent, onPressed: () => _inputOperation('/')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4', color: Colors.black, onPressed: () => _inputNumber('4')),
              _buildButton('5', color: Colors.black, onPressed: () => _inputNumber('5')),
              _buildButton('6', color: Colors.black, onPressed: () => _inputNumber('6')),
              _buildButton('*', color: Colors.orangeAccent, onPressed: () => _inputOperation('*')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1', color: Colors.black, onPressed: () => _inputNumber('1')),
              _buildButton('2', color: Colors.black, onPressed: () => _inputNumber('2')),
              _buildButton('3', color: Colors.black, onPressed: () => _inputNumber('3')),
              _buildButton('-', color: Colors.orangeAccent, onPressed: () => _inputOperation('-')),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('0', color: Colors.black, onPressed: () => _inputNumber('0')),
              _buildButton('C', color: Colors.redAccent, onPressed: _clear),
              _buildButton('=', color: Colors.greenAccent, onPressed: _calculate),
              _buildButton('+', color: Colors.orangeAccent, onPressed: () => _inputOperation('+')),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
