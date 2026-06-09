import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/optimization_result.dart';
import '../services/sequence_optimizer_service.dart';

class SequenceOptimizerProvider extends ChangeNotifier {
  final SequenceOptimizerService _service = SequenceOptimizerService();

  List<int> currentSequence = [];

  OptimizationResult? ascResult;
  OptimizationResult? descResult;
  OptimizationResult? constantResult;
  OptimizationResult? bestResult;

  bool isLoading = false;
  String? errorMessage;

  List<String> history = [];

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    history = prefs.getStringList('sequence_history') ?? [];
    notifyListeners();
  }

  Future<void> _saveHistory(String item) async {
    final prefs = await SharedPreferences.getInstance();

    history.add(item);

    if (history.length > 20) {
      history = history.sublist(history.length - 20);
    }

    await prefs.setStringList('sequence_history', history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sequence_history');
    history = [];
    notifyListeners();
  }

  List<int>? parseSequence(String input) {
    final text = input.trim();

    if (text == '0') {
      return [];
    }

    if (text.isEmpty) {
      errorMessage = 'Debe ingresar una secuencia.';
      return null;
    }

    final parts = text.split(RegExp(r'\s+'));
    final numbers = <int>[];

    for (final part in parts) {
      final value = int.tryParse(part);

      if (value == null) {
        errorMessage = 'La secuencia solo debe contener números enteros.';
        return null;
      }

      if (value <= 0) {
        errorMessage = 'Todos los números deben ser enteros positivos.';
        return null;
      }

      numbers.add(value);
    }

    if (numbers.length > 6) {
      errorMessage = 'La práctica permite secuencias de hasta 6 elementos.';
      return null;
    }

    errorMessage = null;
    return numbers;
  }

  Future<void> processSequence(String input) async {
    final parsed = parseSequence(input);

    if (parsed == null) {
      notifyListeners();
      return;
    }

    if (parsed.isEmpty) {
      errorMessage = 'Entrada 0 detectada. En consola sería salida del sistema.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    currentSequence = parsed;

    ascResult = _service.ordenarAscendenteMinimo(parsed);
    descResult = _service.ordenarDescendenteMinimo(parsed);
    constantResult = _service.estrategiaConstante(parsed);

    bestResult = _service.mejorEstrategia(
      ascResult!,
      descResult!,
      constantResult!,
    );

    await _saveHistory(
      'Secuencia: ${parsed.join(' ')} | Mejor: ${bestResult!.strategyName} | Costo: ${bestResult!.totalCost}',
    );

    isLoading = false;
    notifyListeners();
  }

  void clearResults() {
    currentSequence = [];
    ascResult = null;
    descResult = null;
    constantResult = null;
    bestResult = null;
    errorMessage = null;
    notifyListeners();
  }
}
