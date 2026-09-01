import 'package:flutter_test/flutter_test.dart';
import 'package:solar_pju/app/app.dart';

void main() {
  testWidgets('App smoke test renders LandingScreen, HomeScreen, and ControlScreen',
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

    // Tap 'Kontrol' tab and verify ControlScreen
    await tester.tap(find.text('Kontrol'));
    await tester.pumpAndSettle();

    expect(find.text('Kontrol Lampu'), findsOneWidget);
    expect(find.text('Atur pengoperasian lampu dari sini.'), findsOneWidget);
    expect(find.text('OTOMATIS'), findsOneWidget);
    expect(find.text('MANUAL'), findsOneWidget);
    expect(find.text('Mode otomatis aktif. Lampu dikendalikan oleh sistem.'),
        findsOneWidget);

    // Switch to Manual mode
    await tester.tap(find.text('MANUAL'));
    await tester.pumpAndSettle();

    expect(find.text('Mode manual aktif. Anda dapat mengatur lampu.'),
        findsOneWidget);

    // Tap MATIKAN and verify feedback
    await tester.tap(find.text('MATIKAN'));
    await tester.pump();
    expect(find.text('Lampu dimatikan.'), findsOneWidget);
  });
}
