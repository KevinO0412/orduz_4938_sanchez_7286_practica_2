import 'package:flutter/material.dart';

import '../models/operation_model.dart';

class OperationsTable extends StatelessWidget {
  final List<OperationModel> operations;

  const OperationsTable({
    super.key,
    required this.operations,
  });

  @override
  Widget build(BuildContext context) {
    if (operations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No se requieren operaciones.'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Índice')),
          DataColumn(label: Text('Valor anterior')),
          DataColumn(label: Text('Operación')),
          DataColumn(label: Text('Valor nuevo')),
          DataColumn(label: Text('Costo')),
        ],
        rows: operations.map((op) {
          return DataRow(
            cells: [
              DataCell(Text(op.index.toString())),
              DataCell(Text(op.beforeValue.toString())),
              DataCell(Text(op.operation)),
              DataCell(Text(op.afterValue.toString())),
              DataCell(Text(op.cost.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
