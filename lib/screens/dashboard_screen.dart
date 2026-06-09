import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sequence_optimizer_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/result_card.dart';
import 'login_screen.dart';

enum DashboardSection {
  ingresar,
  historial,
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardSection selectedSection = DashboardSection.ingresar;

  final sequenceController = TextEditingController(text: '10 2 5');

  void addToSequence(String value) {
    final current = sequenceController.text;

    sequenceController.text = current + value;
    sequenceController.selection = TextSelection.fromPosition(
      TextPosition(offset: sequenceController.text.length),
    );

    setState(() {});
  }

  void deleteLastCharacter() {
    final current = sequenceController.text;

    if (current.isEmpty) return;

    sequenceController.text = current.substring(0, current.length - 1);
    sequenceController.selection = TextSelection.fromPosition(
      TextPosition(offset: sequenceController.text.length),
    );

    setState(() {});
  }

  void clearSequenceInput() {
    sequenceController.clear();
    setState(() {});
  }

  void generateRandomSequence() {
    final random = Random();

    final length = random.nextInt(4) + 3; // entre 3 y 6 elementos
    final numbers = List.generate(
      length,
      (_) => random.nextInt(20) + 1, // números entre 1 y 20
    );

    sequenceController.text = numbers.join(' ');
    sequenceController.selection = TextSelection.fromPosition(
      TextPosition(offset: sequenceController.text.length),
    );

    setState(() {});
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required DashboardSection section,
  }) {
    final selected = selectedSection == section;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        selected: selected,
        selectedTileColor: const Color(0xffb2f5ea),
        leading: Icon(icon, color: const Color(0xff063b46)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xff063b46),
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onTap: () {
          setState(() {
            selectedSection = section;
          });
        },
      ),
    );
  }

  Widget buildSidebar() {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffe6fffb),
            Color(0xffccfbf1),
            Color(0xff99f6e4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xff5eead4),
                ),
              ),
              child: Image.asset(
                'assets/images/neuro_ciencia_logo.png',
                width: 185,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 30),
          menuItem(
            icon: Icons.edit_note,
            title: 'Ingresar secuencia',
            section: DashboardSection.ingresar,
          ),
          menuItem(
            icon: Icons.history,
            title: 'Historial',
            section: DashboardSection.historial,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color(0xff063b46),
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Color(0xff063b46),
                fontWeight: FontWeight.w700,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeader(String title) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff102a43),
                ),
              ),
              const SizedBox(height: 8),
              const Chip(
                avatar: Icon(Icons.person),
                label: Text('Usuario: Administrador'),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff102a43),
                ),
              ),
            ),
            const Chip(
              avatar: Icon(Icons.person),
              label: Text('Usuario: Administrador'),
            ),
          ],
        );
      },
    );
  }

  Widget buildIntroCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xffe6fffb),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.psychology_alt,
                size: 44,
                color: Color(0xff00b8c4),
              ),
            ),
            const SizedBox(width: 18),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optimización de secuencias neuronales',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff102a43),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ingrese una secuencia de enteros positivos. El sistema calculará la mejor transformación usando orden ascendente, descendente y constante, aplicando recursividad con memoización.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff52727a),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget virtualKey({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.white,
              foregroundColor: foregroundColor ?? const Color(0xff063b46),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xff99f6e4)),
              ),
            ),
            onPressed: onPressed,
            child: icon == null
                ? Text(
                    label,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : Icon(icon),
          ),
        ),
      ),
    );
  }

  Widget buildVirtualKeyboard() {
    return Card(
      elevation: 1,
      color: const Color(0xfff0fdfa),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xff99f6e4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.keyboard, color: Color(0xff00b8c4)),
                SizedBox(width: 8),
                Text(
                  'Teclado virtual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff102a43),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                virtualKey(label: '1', onPressed: () => addToSequence('1')),
                virtualKey(label: '2', onPressed: () => addToSequence('2')),
                virtualKey(label: '3', onPressed: () => addToSequence('3')),
              ],
            ),
            Row(
              children: [
                virtualKey(label: '4', onPressed: () => addToSequence('4')),
                virtualKey(label: '5', onPressed: () => addToSequence('5')),
                virtualKey(label: '6', onPressed: () => addToSequence('6')),
              ],
            ),
            Row(
              children: [
                virtualKey(label: '7', onPressed: () => addToSequence('7')),
                virtualKey(label: '8', onPressed: () => addToSequence('8')),
                virtualKey(label: '9', onPressed: () => addToSequence('9')),
              ],
            ),
            Row(
              children: [
                virtualKey(
                  label: 'Espacio',
                  onPressed: () => addToSequence(' '),
                  flex: 2,
                  backgroundColor: const Color(0xffccfbf1),
                ),
                virtualKey(label: '0', onPressed: () => addToSequence('0')),
                virtualKey(
                  label: 'Borrar',
                  onPressed: deleteLastCharacter,
                  icon: Icons.backspace,
                  backgroundColor: const Color(0xffffedd5),
                  foregroundColor: const Color(0xff9a3412),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                virtualKey(
                  label: 'Aleatoria',
                  onPressed: generateRandomSequence,
                  icon: Icons.casino,
                  flex: 2,
                  backgroundColor: const Color(0xff00b8c4),
                  foregroundColor: Colors.white,
                ),
                virtualKey(
                  label: 'Limpiar',
                  onPressed: clearSequenceInput,
                  icon: Icons.cleaning_services,
                  backgroundColor: const Color(0xffe0f2fe),
                  foregroundColor: const Color(0xff0369a1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFrequencySummary(SequenceOptimizerProvider provider) {
    final asc = provider.ascResult;
    final desc = provider.descResult;
    final constant = provider.constantResult;

    if (provider.bestResult == null ||
        asc == null ||
        desc == null ||
        constant == null) {
      return const SizedBox.shrink();
    }

    final total = asc.totalCost + desc.totalCost + constant.totalCost;

    double percentage(int cost) {
      if (total == 0) return 0;
      return cost / total;
    }

    Widget frequencyItem({
      required String title,
      required int cost,
      required Color color,
      required IconData icon,
    }) {
      return Expanded(
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.12),
                      foregroundColor: color,
                      child: Icon(icon),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xff102a43),
                        ),
                      ),
                    ),
                    Text(
                      cost.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Color(0xff102a43),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: percentage(cost),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: color,
                  backgroundColor: const Color(0xffe2e8f0),
                ),
                const SizedBox(height: 8),
                Text(
                  'Costo total: $cost',
                  style: const TextStyle(
                    color: Color(0xff52727a),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        const Text(
          'Comparación de costos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xff102a43),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            frequencyItem(
              title: 'Ascendente',
              cost: asc.totalCost,
              color: const Color(0xff00b8c4),
              icon: Icons.trending_up,
            ),
            const SizedBox(width: 12),
            frequencyItem(
              title: 'Descendente',
              cost: desc.totalCost,
              color: const Color(0xff7c3aed),
              icon: Icons.trending_down,
            ),
            const SizedBox(width: 12),
            frequencyItem(
              title: 'Constante',
              cost: constant.totalCost,
              color: const Color(0xff06d6a0),
              icon: Icons.balance,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSummaryCards(SequenceOptimizerProvider provider) {
    final best = provider.bestResult;

    if (best == null) {
      return Row(
        children: const [
          DashboardCard(
            icon: Icons.numbers,
            title: 'Elementos',
            value: '0',
            color: Color(0xff00b8c4),
          ),
          DashboardCard(
            icon: Icons.route,
            title: 'Mejor estrategia',
            value: '-',
            color: Color(0xff008c95),
          ),
          DashboardCard(
            icon: Icons.attach_money,
            title: 'Costo mínimo',
            value: '-',
            color: Color(0xff06d6a0),
          ),
          DashboardCard(
            icon: Icons.memory,
            title: 'Estados memoizados',
            value: '-',
            color: Color(0xfff59e0b),
          ),
        ],
      );
    }

    return Row(
      children: [
        DashboardCard(
          icon: Icons.numbers,
          title: 'Elementos',
          value: provider.currentSequence.length.toString(),
          color: const Color(0xff00b8c4),
        ),
        DashboardCard(
          icon: Icons.route,
          title: 'Mejor estrategia',
          value: best.strategyName,
          color: const Color(0xff008c95),
        ),
        DashboardCard(
          icon: Icons.attach_money,
          title: 'Costo mínimo',
          value: best.totalCost.toString(),
          color: const Color(0xff06d6a0),
        ),
        DashboardCard(
          icon: Icons.memory,
          title: 'Estados memoizados',
          value: best.memoStates.toString(),
          color: const Color(0xfff59e0b),
        ),
      ],
    );
  }

  Widget buildIngresar(SequenceOptimizerProvider provider) {
    final messenger = ScaffoldMessenger.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader('Ingresar secuencia'),
        const SizedBox(height: 18),
        buildIntroCard(),
        const SizedBox(height: 18),
        buildSummaryCards(provider),
        const SizedBox(height: 22),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Secuencia a analizar',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff102a43),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use el teclado virtual o escriba números enteros positivos separados por espacios. Máximo 6 elementos.',
                  style: TextStyle(color: Color(0xff52727a)),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: sequenceController,
                  readOnly: false,
                  decoration: InputDecoration(
                    labelText: 'Secuencia',
                    hintText: 'Ejemplo: 10 2 5',
                    prefixIcon: const Icon(Icons.numbers),
                    suffixIcon: IconButton(
                      onPressed: clearSequenceInput,
                      icon: const Icon(Icons.close),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                buildVirtualKeyboard(),
                const SizedBox(height: 18),
                if (provider.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (provider.isLoading) const LinearProgressIndicator(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              await provider.processSequence(
                                sequenceController.text,
                              );

                              if (!mounted) return;

                              if (provider.bestResult != null) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Secuencia procesada correctamente.',
                                    ),
                                  ),
                                );
                              }
                            },
                      icon: const Icon(Icons.calculate),
                      label: const Text('Procesar secuencia'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        provider.clearResults();
                        clearSequenceInput();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Limpiar todo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (provider.bestResult != null) ...[
          const SizedBox(height: 22),
          ResultCard(result: provider.bestResult!, highlighted: true),
          buildFrequencySummary(provider),
          const SizedBox(height: 22),
          const Text(
            'Resultados completos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xff102a43),
            ),
          ),
          const SizedBox(height: 10),
          ResultCard(result: provider.ascResult!),
          const SizedBox(height: 12),
          ResultCard(result: provider.descResult!),
          const SizedBox(height: 12),
          ResultCard(result: provider.constantResult!),
        ],
      ],
    );
  }

  Widget buildHistorial(SequenceOptimizerProvider provider) {
    final reversed = provider.history.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader('Historial'),
        const SizedBox(height: 18),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => provider.loadHistory(),
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: reversed.isEmpty ? null : () => provider.clearHistory(),
              icon: const Icon(Icons.delete),
              label: const Text('Limpiar historial'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (reversed.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No hay análisis guardados todavía.'),
            ),
          )
        else
          Column(
            children: reversed.map((item) {
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffe6fffb),
                    foregroundColor: Color(0xff00b8c4),
                    child: Icon(Icons.history),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xff102a43),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget buildSelectedSection(SequenceOptimizerProvider provider) {
    switch (selectedSection) {
      case DashboardSection.ingresar:
        return buildIngresar(provider);
      case DashboardSection.historial:
        return buildHistorial(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SequenceOptimizerProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Row(
            children: [
              buildSidebar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: SingleChildScrollView(
                    child: buildSelectedSection(provider),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
