import 'package:flutter_test/flutter_test.dart';
import 'package:orduz_4938_sanchez_7286_practica_2/main.dart';

void main() {
  testWidgets('NeuroRuta app carga correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const NeuroRutaApp());

    expect(find.text('NEURO CIENCIA SC'), findsOneWidget);
  });
}
