import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:solar_pju/app/app.dart';
import 'package:solar_pju/app/theme/app_theme.dart';
import 'package:solar_pju/providers/pju_provider.dart';
import 'package:solar_pju/screens/chatbot/chatbot_screen.dart';
import 'package:solar_pju/screens/control/control_screen.dart';

void main() {
  testWidgets('App smoke test renders LandingScreen and navigates to HomeScreen',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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

  testWidgets('ControlScreen handles mode switching and lamp controls',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PJUProvider(),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ControlScreen(),
        ),
      ),
    );

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

  testWidgets('Tanya SINAR opens BottomSheet and answers selected question',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PJUProvider(),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ChatbotScreen(),
        ),
      ),
    );

    expect(find.text('Tanya SINAR'), findsOneWidget);
    expect(find.text('Informasi sederhana tentang kondisi sistem.'),
        findsOneWidget);
    expect(
      find.text(
          'Halo! Saya SINAR.\nSilakan pilih pertanyaan untuk mengetahui kondisi sistem.'),
      findsOneWidget,
    );
    expect(find.text('Pilihan Pertanyaan'), findsOneWidget);

    // Tap 'Pilihan Pertanyaan' to open BottomSheet
    await tester.tap(find.text('Pilihan Pertanyaan'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih Pertanyaan'), findsOneWidget);
    expect(find.text('Silakan pilih informasi yang ingin diketahui.'),
        findsOneWidget);
    expect(find.text('Apakah lampu menyala?'), findsOneWidget);
    expect(find.text('Berapa baterai sekarang?'), findsOneWidget);
    expect(find.text('Berapa tegangan saat ini?'), findsOneWidget);
    expect(find.text('Bagaimana kondisi panel surya?'), findsOneWidget);
    expect(find.text('Bagaimana kondisi sistem?'), findsOneWidget);
    expect(find.text('Ada potensi kerusakan?'), findsOneWidget);

    // Select a question from bottom sheet
    await tester.tap(find.text('Berapa baterai sekarang?'));
    await tester.pumpAndSettle();

    expect(find.text('Berapa baterai sekarang?'), findsOneWidget);
    expect(find.textContaining('Baterai saat ini 78%'), findsOneWidget);
    expect(find.text('Pilihan Pertanyaan'), findsOneWidget);

    // Tap 'Pilihan Pertanyaan' again and test prediction question
    await tester.tap(find.text('Pilihan Pertanyaan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ada potensi kerusakan?'));
    await tester.pumpAndSettle();

    expect(find.text('Ada potensi kerusakan?'), findsOneWidget);
    expect(find.textContaining('Prediksi: BELUM TERSEDIA'), findsOneWidget);
  });
}
