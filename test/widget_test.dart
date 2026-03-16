
import 'package:flutter_test/flutter_test.dart';

// Cambia 'apii' por el nombre que definiste en tu pubspec.yaml
import 'package:apii/main.dart'; 

void main() {
  testWidgets('Welcome screen shows app title', (WidgetTester tester) async {
    // Cargamos la app
    await tester.pumpWidget(const MyApp());

    // Verificamos que los textos existan
    // Asegúrate de que estos textos sean EXACTAMENTE iguales a los de tu WelcomeScreen
    expect(find.text('SGVI - Gestión de Ventas'), findsOneWidget);
    expect(find.text('Ingresar como Admin'), findsOneWidget);
    expect(find.text('Ingresar como Vendedor'), findsOneWidget);
  });
}