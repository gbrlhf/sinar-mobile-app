import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../main_shell.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // BAGIAN 1: BRANDING ATAS
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'SINAR',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryGreen,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ),

                      // BAGIAN 2 & 3 & 4 & 5: ILUSTRASI + JUDUL + DESKRIPSI + IDENTITAS
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ILUSTRASI SISTEM PENERANGAN TENAGA SURYA
                            const SizedBox(
                              height: 170,
                              width: 190,
                              child: _SolarStreetLightIllustration(),
                            ),
                            const SizedBox(height: 24),

                            // NAMA APLIKASI
                            const Text(
                              'SINAR',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // KEPANJANGAN / JUDUL
                            const Text(
                              'Sistem Informasi dan Kendali\nPenerangan Tenaga Surya',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // DESKRIPSI SINGKAT
                            const Text(
                              'Pantau kondisi penerangan dan\nkendalikan lampu dengan mudah.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // IDENTITAS KKN
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lightGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'by KKN TRIN 27',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryGreen,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // BAGIAN 6: TOMBOL MASUK KE APLIKASI
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const MainShell(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Masuk ke Aplikasi',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Flat vector illustration depicting a solar-powered street light
class _SolarStreetLightIllustration extends StatelessWidget {
  const _SolarStreetLightIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SolarStreetLightPainter(),
      size: const Size(190, 170),
    );
  }
}

class _SolarStreetLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Soft Background Aura for Sun
    final sunCenter = Offset(w * 0.78, h * 0.22);
    final sunAuraPaint = Paint()
      ..color = const Color(0xFFFFF9C4).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, 28, sunAuraPaint);

    // 2. Matahari Sederhana (Sun Core)
    final sunPaint = Paint()
      ..color = const Color(0xFFFBC02D)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, 16, sunPaint);

    // Subtle sun rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFDD835)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rayOffsets = [
      Offset(0, -22),
      Offset(0, 22),
      Offset(-22, 0),
      Offset(22, 0),
      Offset(-16, -16),
      Offset(16, -16),
      Offset(-16, 16),
      Offset(16, 16),
    ];
    for (final offset in rayOffsets) {
      canvas.drawLine(
        sunCenter + offset * 0.82,
        sunCenter + offset * 1.15,
        rayPaint,
      );
    }

    // 3. Ground Grass Mound (Landasan Hijau Halus)
    final groundPath = Path()
      ..moveTo(w * 0.08, h * 0.94)
      ..quadraticBezierTo(w * 0.5, h * 0.88, w * 0.92, h * 0.94)
      ..lineTo(w * 0.92, h * 0.98)
      ..lineTo(w * 0.08, h * 0.98)
      ..close();

    final groundPaint = Paint()
      ..color = const Color(0xFFC8E6C9)
      ..style = PaintingStyle.fill;
    canvas.drawPath(groundPath, groundPaint);

    // 4. Lamp Light Beam (Pancaran Cahaya Lampu Menyala)
    final lightBeamPath = Path()
      ..moveTo(w * 0.32, h * 0.38)
      ..lineTo(w * 0.12, h * 0.92)
      ..lineTo(w * 0.58, h * 0.92)
      ..close();

    final lightBeamPaint = Paint()
      ..color = const Color(0xFFFFF59D).withValues(alpha: 0.38)
      ..style = PaintingStyle.fill;
    canvas.drawPath(lightBeamPath, lightBeamPaint);

    // 5. Street Light Pole (Tiang Lampu Jalan)
    final polePaint = Paint()
      ..color = const Color(0xFF37474F)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Vertical straight pole
    canvas.drawLine(
      Offset(w * 0.48, h * 0.25),
      Offset(w * 0.48, h * 0.93),
      polePaint,
    );

    // Pole Base
    final basePaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.fill;
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.48, h * 0.93),
        width: 22,
        height: 6,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(baseRect, basePaint);

    // Curved Arm holding lamp
    final armPath = Path()
      ..moveTo(w * 0.48, h * 0.30)
      ..cubicTo(
        w * 0.48,
        h * 0.22,
        w * 0.32,
        h * 0.22,
        w * 0.32,
        h * 0.35,
      );

    final armPaint = Paint()
      ..color = const Color(0xFF37474F)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(armPath, armPaint);

    // 6. Lamp Head (Rumah Lampu LED)
    final lampHeadPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.fill;

    final lampHeadPath = Path()
      ..moveTo(w * 0.26, h * 0.35)
      ..lineTo(w * 0.38, h * 0.35)
      ..lineTo(w * 0.35, h * 0.38)
      ..lineTo(w * 0.29, h * 0.38)
      ..close();
    canvas.drawPath(lampHeadPath, lampHeadPaint);

    // Glowing LED emitter on lamp
    final ledPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.32, h * 0.38),
        width: 7,
        height: 3,
      ),
      ledPaint,
    );

    // 7. Solar Panel Mount & Panel (Panel Surya di Bagian Atas)
    // Mounting bracket
    final mountPaint = Paint()
      ..color = const Color(0xFF455A64)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.48, h * 0.25),
      Offset(w * 0.58, h * 0.19),
      mountPaint,
    );

    // Angled Solar Panel
    canvas.save();
    canvas.translate(w * 0.58, h * 0.19);
    canvas.rotate(-0.35); // Angled towards the sun

    final panelBodyPaint = Paint()
      ..color = const Color(0xFF1565C0) // Solar blue
      ..style = PaintingStyle.fill;
    final panelBorderPaint = Paint()
      ..color = const Color(0xFFE0E0E0) // Aluminum frame
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final panelRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 36, height: 18),
      const Radius.circular(2),
    );
    canvas.drawRRect(panelRect, panelBodyPaint);
    canvas.drawRRect(panelRect, panelBorderPaint);

    // Grid lines on solar panel
    final gridPaint = Paint()
      ..color = const Color(0xFF90CAF9)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(-18, 0), const Offset(18, 0), gridPaint);
    canvas.drawLine(const Offset(-6, -9), const Offset(-6, 9), gridPaint);
    canvas.drawLine(const Offset(6, -9), const Offset(6, 9), gridPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
