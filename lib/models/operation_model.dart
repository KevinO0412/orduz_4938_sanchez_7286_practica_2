class OperationModel {
  final int index;
  final int beforeValue;
  final String operation;
  final int afterValue;
  final int cost;

  OperationModel({
    required this.index,
    required this.beforeValue,
    required this.operation,
    required this.afterValue,
    required this.cost,
  });
}
