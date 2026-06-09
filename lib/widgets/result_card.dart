import 'package:flutter/material.dart';

import '../models/optimization_result.dart';
import 'operations_table.dart';

class ResultCard extends StatelessWidget {
  final OptimizationResult result;
  final bool highlighted;

  const ResultCard({
    super.key,
    required this.result,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlighted ? const Color(0xffe6fffb) : Colors.white,
      elevation: highlighted ? 5 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: highlighted ? const Color(0xff00b8c4) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  highlighted ? Icons.star : Icons.route,
                  color: highlighted
                      ? const Color(0xff00b8c4)
                      : const Color(0xff52727a),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    result.strategyName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff102a43),
                    ),
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.attach_money),
                  label: Text('Costo: ${result.totalCost}'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Secuencia original: ${result.originalSequence.join('  ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Secuencia final: ${result.finalSequence.join('  ')}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (result.targetValue != null) ...[
              const SizedBox(height: 6),
              Text(
                'Valor objetivo óptimo: ${result.targetValue}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 6),
            Text(
              'Estados memoizados: ${result.memoStates}',
              style: const TextStyle(color: Color(0xff52727a)),
            ),
            const SizedBox(height: 18),
            const Text(
              'Operaciones aplicadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            OperationsTable(operations: result.operations),
          ],
        ),
      ),
    );
  }
}
