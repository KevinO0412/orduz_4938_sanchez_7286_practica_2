import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sequence_optimizer_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/result_card.dart';
import 'login_screen.dart';

enum DashboardSection {
  inicio,
  ingresar,
  ascendente,
  descendente,
  comparacion,
  constante,
  historial,
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardSection selectedSection = DashboardSection.inicio;

  final sequenceController = TextEditingController(text: '10 2 5');

  Widget menuItem({
    required IconData icon,
    required String title,
    required DashboardSection section,
  }) {
    final selected = selectedSection == section;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        selected: selected,
        selectedTileColor: const Color(0xffb2f5ea),
        leading: Icon(icon, color: const Color(0xff063b46)),
        title: Text(title, style: const TextStyle(color: Color(0xff063b46))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(22),
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
          const SizedBox(height: 28),
          menuItem(
            icon: Icons.dashboard,
            title: 'Inicio',
            section: DashboardSection.inicio,
          ),
          menuItem(
            icon: Icons.edit_note,
            title: 'Ingresar secuencia',
            section: DashboardSection.ingresar,
          ),
          menuItem(
            icon: Icons.trending_up,
            title: 'Ascendente',
            section: DashboardSection.ascendente,
          ),
          menuItem(
            icon: Icons.trending_down,
            title: 'Descendente',
            section: DashboardSection.descendente,
          ),
          menuItem(
            icon: Icons.compare_arrows,
            title: 'Comparación',
            section: DashboardSection.comparacion,
          ),
          menuItem(
            icon: Icons.balance,
            title: 'Constante',
            section: DashboardSection.constante,
          ),
          menuItem(
            icon: Icons.history,
            title: 'Historial',
            section: DashboardSection.historial,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xff063b46)),
            title: const Text('Salir', style: TextStyle(color: Color(0xff063b46))),
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

  Widget buildInicio(SequenceOptimizerProvider provider) {
    final best = provider.bestResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader('Panel principal'),
        const SizedBox(height: 18),
        Row(
          children: [
            DashboardCard(
              icon: Icons.numbers,
              title: 'Elementos',
              value: provider.currentSequence.isEmpty
                  ? '0'
                  : provider.currentSequence.length.toString(),
              color: const Color(0xff00b8c4),
            ),
            DashboardCard(
              icon: Icons.route,
              title: 'Mejor estrategia',
              value: best == null ? '-' : best.strategyName,
              color: const Color(0xff008c95),
            ),
            DashboardCard(
              icon: Icons.attach_money,
              title: 'Costo mínimo',
              value: best == null ? '-' : best.totalCost.toString(),
              color: const Color(0xff10b981),
            ),
            DashboardCard(
              icon: Icons.memory,
              title: 'Memoización',
              value: best == null ? '-' : best.memoStates.toString(),
              color: const Color(0xfff59e0b),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.psychology_alt,
                  size: 60,
                  color: Color(0xff00b8c4),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sistema de optimización de secuencias neuronales',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ingrese una secuencia de números enteros positivos. El sistema calculará la transformación mínima para orden ascendente, descendente y constante usando recursividad con memoización.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedSection = DashboardSection.ingresar;
                          });
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Comenzar análisis'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (best != null) ...[
          const SizedBox(height: 22),
          ResultCard(result: best, highlighted: true),
        ],
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
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingrese números enteros positivos separados por espacios.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ejemplo: 10 2 5',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: sequenceController,
                  decoration: InputDecoration(
                    labelText: 'Secuencia',
                    hintText: 'Ejemplo: 5 3 8',
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
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

                                setState(() {
                                  selectedSection =
                                      DashboardSection.comparacion;
                                });
                              }
                            },
                      icon: const Icon(Icons.calculate),
                      label: const Text('Procesar secuencia'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        provider.clearResults();
                        sequenceController.clear();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Limpiar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildResultOnly({
    required SequenceOptimizerProvider provider,
    required String title,
    required dynamic result,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(title),
        const SizedBox(height: 18),
        if (result == null)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Primero debe ingresar y procesar una secuencia.'),
            ),
          )
        else
          ResultCard(result: result),
      ],
    );
  }

  Widget buildComparacion(SequenceOptimizerProvider provider) {
    final asc = provider.ascResult;
    final desc = provider.descResult;
    final constant = provider.constantResult;
    final best = provider.bestResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader('Comparación de estrategias'),
        const SizedBox(height: 18),
        if (best == null)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Primero debe ingresar y procesar una secuencia.'),
            ),
          )
        else ...[
          ResultCard(result: best, highlighted: true),
          const SizedBox(height: 18),
          Row(
            children: [
              DashboardCard(
                icon: Icons.trending_up,
                title: 'Ascendente',
                value: asc!.totalCost.toString(),
                color: const Color(0xff00b8c4),
              ),
              DashboardCard(
                icon: Icons.trending_down,
                title: 'Descendente',
                value: desc!.totalCost.toString(),
                color: const Color(0xff7c3aed),
              ),
              DashboardCard(
                icon: Icons.balance,
                title: 'Constante',
                value: constant!.totalCost.toString(),
                color: const Color(0xff10b981),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Text(
                'La estrategia más económica fue "${best.strategyName}" con un costo total de ${best.totalCost}.',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildHistorial(SequenceOptimizerProvider provider) {
    final reversed = provider.history.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader('Historial de análisis'),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(item),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget buildSelectedSection(SequenceOptimizerProvider provider) {
    switch (selectedSection) {
      case DashboardSection.inicio:
        return buildInicio(provider);
      case DashboardSection.ingresar:
        return buildIngresar(provider);
      case DashboardSection.ascendente:
        return buildResultOnly(
          provider: provider,
          title: 'Secuencia mínima ascendente',
          result: provider.ascResult,
        );
      case DashboardSection.descendente:
        return buildResultOnly(
          provider: provider,
          title: 'Secuencia mínima descendente',
          result: provider.descResult,
        );
      case DashboardSection.comparacion:
        return buildComparacion(provider);
      case DashboardSection.constante:
        return buildResultOnly(
          provider: provider,
          title: 'Secuencia constante',
          result: provider.constantResult,
        );
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
