import '../models/operation_model.dart';
import '../models/optimization_result.dart';

class ElementStep {
  final int beforeValue;
  final String operation;
  final int afterValue;
  final int cost;

  ElementStep({
    required this.beforeValue,
    required this.operation,
    required this.afterValue,
    required this.cost,
  });
}

class ElementTransformResult {
  final int cost;
  final List<ElementStep> steps;

  ElementTransformResult({
    required this.cost,
    required this.steps,
  });
}

class _NodeResult {
  final int cost;
  final List<int> finalValues;
  final List<OperationModel> operations;

  _NodeResult({
    required this.cost,
    required this.finalValues,
    required this.operations,
  });
}

class SequenceOptimizerService {
  final Map<String, ElementTransformResult> _elementMemo = {};
  final Map<String, _NodeResult> _sequenceMemo = {};

  int lastMemoStates = 0;

  bool esAscendente(List<int> seq) {
    for (int i = 1; i < seq.length; i++) {
      if (seq[i] < seq[i - 1]) {
        return false;
      }
    }
    return true;
  }

  bool esDescendente(List<int> seq) {
    for (int i = 1; i < seq.length; i++) {
      if (seq[i] > seq[i - 1]) {
        return false;
      }
    }
    return true;
  }

  int transformarElemento(int value, String operation) {
    switch (operation) {
      case '+1':
        return value + 1;
      case '-1':
        return value - 1;
      case '*2':
        return value * 2;
      case '/2':
        if (value % 2 == 0) {
          return value ~/ 2;
        }
        return value;
      default:
        return value;
    }
  }

  List<int> _generateCandidates(List<int> sequence) {
    final minValue = sequence.reduce((a, b) => a < b ? a : b);
    final maxValue = sequence.reduce((a, b) => a > b ? a : b);

    final start = (minValue - 10) < 1 ? 1 : minValue - 10;
    final end = (maxValue * 2 + 10);

    return List.generate(end - start + 1, (index) => start + index);
  }

  ElementTransformResult _bestTransformElement({
    required int from,
    required int to,
    required int maxLimit,
  }) {
    final key = '$from->$to-$maxLimit';

    if (_elementMemo.containsKey(key)) {
      return _elementMemo[key]!;
    }

    if (from == to) {
      final result = ElementTransformResult(cost: 0, steps: []);
      _elementMemo[key] = result;
      return result;
    }

    final distances = <int, int>{};
    final previousValue = <int, int>{};
    final previousOperation = <int, String>{};
    final previousCost = <int, int>{};
    final visited = <int>{};

    for (int i = 1; i <= maxLimit; i++) {
      distances[i] = 1000000000;
    }

    distances[from] = 0;

    while (visited.length < maxLimit) {
      int? current;
      int currentDistance = 1000000000;

      distances.forEach((value, distance) {
        if (!visited.contains(value) && distance < currentDistance) {
          current = value;
          currentDistance = distance;
        }
      });

      if (current == null) {
        break;
      }

      if (current == to) {
        break;
      }

      visited.add(current!);

      final options = <Map<String, dynamic>>[];

      if (current! + 1 <= maxLimit) {
        options.add({
          'next': current! + 1,
          'op': '+1',
          'cost': 1,
        });
      }

      if (current! - 1 >= 1) {
        options.add({
          'next': current! - 1,
          'op': '-1',
          'cost': 1,
        });
      }

      if (current! * 2 <= maxLimit) {
        options.add({
          'next': current! * 2,
          'op': '*2',
          'cost': 3,
        });
      }

      if (current! % 2 == 0) {
        options.add({
          'next': current! ~/ 2,
          'op': '/2',
          'cost': 2,
        });
      }

      for (final option in options) {
        final next = option['next'] as int;
        final op = option['op'] as String;
        final cost = option['cost'] as int;

        final newDistance = distances[current!]! + cost;

        if (newDistance < distances[next]!) {
          distances[next] = newDistance;
          previousValue[next] = current!;
          previousOperation[next] = op;
          previousCost[next] = cost;
        }
      }
    }

    final steps = <ElementStep>[];

    int walker = to;

    while (walker != from && previousValue.containsKey(walker)) {
      final before = previousValue[walker]!;
      final op = previousOperation[walker]!;
      final cost = previousCost[walker]!;

      steps.insert(
        0,
        ElementStep(
          beforeValue: before,
          operation: op,
          afterValue: walker,
          cost: cost,
        ),
      );

      walker = before;
    }

    final result = ElementTransformResult(
      cost: distances[to] ?? 1000000000,
      steps: steps,
    );

    _elementMemo[key] = result;
    return result;
  }

  OptimizationResult ordenarAscendenteMinimo(List<int> sequence) {
    return _buscarMejorSecuencia(
      sequence: sequence,
      strategyName: 'Orden Ascendente',
      ascending: true,
    );
  }

  OptimizationResult ordenarDescendenteMinimo(List<int> sequence) {
    return _buscarMejorSecuencia(
      sequence: sequence,
      strategyName: 'Orden Descendente',
      ascending: false,
    );
  }

  OptimizationResult _buscarMejorSecuencia({
    required List<int> sequence,
    required String strategyName,
    required bool ascending,
  }) {
    _sequenceMemo.clear();

    final candidates = _generateCandidates(sequence);
    final maxLimit = candidates.last + 20;

    _NodeResult solve(int index, int previous) {
      final key = '$strategyName|$index|$previous';

      if (_sequenceMemo.containsKey(key)) {
        return _sequenceMemo[key]!;
      }

      if (index == sequence.length) {
        return _NodeResult(
          cost: 0,
          finalValues: [],
          operations: [],
        );
      }

      _NodeResult? best;

      for (final target in candidates) {
        final valid = ascending ? target >= previous : target <= previous;

        if (!valid) {
          continue;
        }

        final transform = _bestTransformElement(
          from: sequence[index],
          to: target,
          maxLimit: maxLimit,
        );

        final next = solve(index + 1, target);

        final totalCost = transform.cost + next.cost;

        final currentOperations = transform.steps.map((step) {
          return OperationModel(
            index: index,
            beforeValue: step.beforeValue,
            operation: step.operation,
            afterValue: step.afterValue,
            cost: step.cost,
          );
        }).toList();

        final candidateResult = _NodeResult(
          cost: totalCost,
          finalValues: [target, ...next.finalValues],
          operations: [...currentOperations, ...next.operations],
        );

        if (best == null || candidateResult.cost < best.cost) {
          best = candidateResult;
        }
      }

      best ??= _NodeResult(
        cost: 1000000000,
        finalValues: [],
        operations: [],
      );

      _sequenceMemo[key] = best;
      return best;
    }

    final initialPrevious = ascending ? 1 : candidates.last;
    final result = solve(0, initialPrevious);

    lastMemoStates = _sequenceMemo.length;

    return OptimizationResult(
      strategyName: strategyName,
      originalSequence: sequence,
      finalSequence: result.finalValues,
      operations: result.operations,
      totalCost: result.cost,
      memoStates: lastMemoStates,
    );
  }

  OptimizationResult estrategiaConstante(List<int> sequence) {
    final candidates = _generateCandidates(sequence);
    final maxLimit = candidates.last + 20;

    int bestCost = 1000000000;
    int bestTarget = sequence.first;
    List<OperationModel> bestOperations = [];

    for (final target in candidates) {
      int total = 0;
      final operations = <OperationModel>[];

      for (int i = 0; i < sequence.length; i++) {
        final transform = _bestTransformElement(
          from: sequence[i],
          to: target,
          maxLimit: maxLimit,
        );

        total += transform.cost;

        operations.addAll(
          transform.steps.map((step) {
            return OperationModel(
              index: i,
              beforeValue: step.beforeValue,
              operation: step.operation,
              afterValue: step.afterValue,
              cost: step.cost,
            );
          }),
        );
      }

      if (total < bestCost) {
        bestCost = total;
        bestTarget = target;
        bestOperations = operations;
      }
    }

    return OptimizationResult(
      strategyName: 'Secuencia Constante',
      originalSequence: sequence,
      finalSequence: List.generate(sequence.length, (_) => bestTarget),
      operations: bestOperations,
      totalCost: bestCost,
      targetValue: bestTarget,
      memoStates: _elementMemo.length,
    );
  }

  OptimizationResult mejorEstrategia(
    OptimizationResult asc,
    OptimizationResult desc,
    OptimizationResult constante,
  ) {
    final results = [asc, desc, constante];

    results.sort((a, b) => a.totalCost.compareTo(b.totalCost));

    return results.first;
  }
}
