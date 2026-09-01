import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_theme.dart';
import '../../models/pju_data.dart';
import '../../providers/pju_provider.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  void _showFeedback(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? AppTheme.statusError : AppTheme.primaryGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pju = context.watch<PJUProvider>();
    final isConnected = pju.connectionStatus.toUpperCase() == 'TERHUBUNG';
    final isLampOn = pju.lampStatus;
    final isAutoMode = pju.operationMode == OperationMode.automatic;
    final isManualAllowed = pju.isManualControlAllowed;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. HEADER (KONSISTEN DENGAN BERANDA)
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SINAR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryGreen,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Penerangan Jalan Umum',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Status Koneksi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isConnected
                          ? AppTheme.lightGreen
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isConnected
                            ? const Color(0xFFA5D6A7)
                            : const Color(0xFFFFCDD2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isConnected
                                ? AppTheme.statusSuccess
                                : AppTheme.statusError,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isConnected ? 'Terhubung' : 'Terputus',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isConnected
                                ? AppTheme.statusSuccess
                                : AppTheme.statusError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 2. JUDUL & SUBTITLE
              // ==========================================
              const Text(
                'Kontrol Lampu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Atur pengoperasian lampu dari sini.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 3. STATUS LAMPU SAAT INI
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: isLampOn
                      ? const Color(0xFFF1F8E9)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isLampOn
                        ? const Color(0xFFC8E6C9)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    // Icon Lampu
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isLampOn
                            ? const Color(0xFFFFF9C4)
                            : const Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLampOn ? Icons.lightbulb : Icons.lightbulb_outline,
                        color: isLampOn
                            ? const Color(0xFFF57F17)
                            : AppTheme.statusDisabled,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Detail Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lampu saat ini:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isLampOn ? 'MENYALA' : 'MATI',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isLampOn
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // 4. MODE PENGOPERASIAN (OTOMATIS / MANUAL)
              // ==========================================
              const Text(
                'Mode Pengoperasian',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Tombol Mode Otomatis
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          pju.setOperationMode(OperationMode.automatic);
                        },
                        icon: Icon(
                          Icons.autorenew,
                          size: 18,
                          color: isAutoMode ? Colors.white : AppTheme.textSecondary,
                        ),
                        label: const Text('OTOMATIS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAutoMode
                              ? AppTheme.primaryGreen
                              : AppTheme.surface,
                          foregroundColor: isAutoMode
                              ? Colors.white
                              : AppTheme.textPrimary,
                          elevation: 0,
                          side: BorderSide(
                            color: isAutoMode
                                ? AppTheme.primaryGreen
                                : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Mode Manual
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          pju.setOperationMode(OperationMode.manual);
                        },
                        icon: Icon(
                          Icons.touch_app_outlined,
                          size: 18,
                          color: !isAutoMode ? Colors.white : AppTheme.textSecondary,
                        ),
                        label: const Text('MANUAL'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isAutoMode
                              ? AppTheme.primaryGreen
                              : AppTheme.surface,
                          foregroundColor: !isAutoMode
                              ? Colors.white
                              : AppTheme.textPrimary,
                          elevation: 0,
                          side: BorderSide(
                            color: !isAutoMode
                                ? AppTheme.primaryGreen
                                : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Keterangan Mode Aktif
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: isAutoMode
                      ? AppTheme.lightGreen
                      : const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isAutoMode
                        ? const Color(0xFFC8E6C9)
                        : const Color(0xFFBBDEFB),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isAutoMode ? Icons.info_outline : Icons.touch_app,
                      size: 18,
                      color: isAutoMode
                          ? AppTheme.primaryGreen
                          : AppTheme.secondaryBlue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isAutoMode
                            ? 'Mode otomatis aktif. Lampu dikendalikan oleh sistem.'
                            : 'Mode manual aktif. Anda dapat mengatur lampu.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isAutoMode
                              ? const Color(0xFF1B5E20)
                              : const Color(0xFF0D47A1),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // 5. TOMBOL KONTROL MANUAL (NYALAKAN & MATIKAN)
              // ==========================================
              const Text(
                'Kontrol Lampu Manual',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Tombol NYALAKAN
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isManualAllowed
                            ? () {
                                final success = pju.turnLampOn();
                                if (success) {
                                  _showFeedback(context, 'Lampu dinyalakan.');
                                } else {
                                  _showFeedback(
                                    context,
                                    'Perintah tidak dapat dilakukan.',
                                    isError: true,
                                  );
                                }
                              }
                            : null,
                        icon: const Icon(Icons.lightbulb, size: 20),
                        label: const Text('NYALAKAN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFE5E7EB),
                          disabledForegroundColor: const Color(0xFF9CA3AF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol MATIKAN
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isManualAllowed
                            ? () {
                                final success = pju.turnLampOff();
                                if (success) {
                                  _showFeedback(context, 'Lampu dimatikan.');
                                } else {
                                  _showFeedback(
                                    context,
                                    'Perintah tidak dapat dilakukan.',
                                    isError: true,
                                  );
                                }
                              }
                            : null,
                        icon: const Icon(Icons.power_settings_new, size: 20),
                        label: const Text('MATIKAN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFE5E7EB),
                          disabledForegroundColor: const Color(0xFF9CA3AF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
