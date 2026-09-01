import 'package:flutter_test/flutter_test.dart';
import 'package:solar_pju/app/app.dart';

void main() {
  testWidgets('App smoke test renders LandingScreen and navigates to HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SolarPjuApp());

    expect(find.text('SINAR'), findsWidgets);
    expect(find.text('Masuk ke Aplikasi'), findsOneWidget);

    // Tap 'Masuk ke Aplikasi' and verify HomeScreen & 3-tab MainShell renders
    await tester.tap(find.text('Masuk ke Aplikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Lampu PJU: MENYALA'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('25,6 V'), findsOneWidget);
    expect(find.text('Kondisi PJU'), findsOneWidget);
    expect(find.text('Riwayat Pemantauan'), findsOneWidget);
    expect(find.text('Perubahan Tegangan'), findsOneWidget);
    expect(find.text('Perubahan Baterai'), findsOneWidget);

    // Verify 3 bottom navigation destinations
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Kontrol'), findsOneWidget);
    expect(find.text('Tanya PJU'), findsOneWidget);
  });
}
