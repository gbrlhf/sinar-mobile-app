import 'package:flutter_test/flutter_test.dart';
import 'package:solar_pju/app/app.dart';

void main() {
  testWidgets('App smoke test renders LandingScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const SolarPjuApp());

    expect(find.text('SINAR'), findsWidgets);
    expect(find.text('Masuk ke Aplikasi'), findsOneWidget);
  });
}
