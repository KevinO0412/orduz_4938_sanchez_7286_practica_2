import 'operation_model.dart';

class OptimizationResult {
  final String strategyName;
  final List<int> originalSequence;
  final List<int> finalSequence;
  final List<OperationModel> operations;
  final int totalCost;
  final int? targetValue;
  final int memoStates;

  OptimizationResult({
    required this.strategyName,
    required this.originalSequence,
    required this.finalSequence,
    required this.operations,
    required this.totalCost,
    this.targetValue,
    this.memoStates = 0,
  });

  bool get hasOperations => operations.isNotEmpty;
}
