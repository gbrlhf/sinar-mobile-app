import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_theme.dart';
import '../../models/monitoring_data.dart';
import '../../models/pju_data.dart';
import '../../providers/pju_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPeriod = 'Hari ini';

  final List<String> _periodOptions = const [
    'Hari ini',
    '7 Hari',
    '30 Hari',
  ];

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatVoltage(double voltage) {
    return '${voltage.toStringAsFixed(1).replaceAll('.', ',')} V';
  }

  @override
  Widget build(BuildContext context) {
    final pju = context.watch<PJUProvider>();
    final isConnected = pju.connectionStatus.toUpperCase() == 'TERHUBUNG';
    final isLampOn = pju.lampStatus;
    final isAutoMode = pju.operationMode == OperationMode.automatic;
    final historicalData = pju.getHistoricalData(_selectedPeriod);

    // Cek apakah seluruh komponen berstatus 'BAIK'
    final allComponentsGood = pju.componentStatus.values.every(
      (status) => status.toUpperCase() == 'BAIK',
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. HEADER
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
              const SizedBox(height: 4),
              Text(
                'Terakhir diperbarui ${_formatTime(pju.updatedAt)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 2. STATUS UTAMA LAMPU
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
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
                      width: 50,
                      height: 50,
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
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Detail Status Lampu
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLampOn ? 'Lampu PJU: MENYALA' : 'Lampu PJU: MATI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isLampOn
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isAutoMode ? 'Mode otomatis' : 'Mode manual',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          if (allComponentsGood) ...[
                            const SizedBox(height: 2),
                            const Text(
                              'Semua dalam kondisi baik',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.statusSuccess,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 3. RINGKASAN DATA
              // ==========================================
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 10) / 2;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Card Baterai
                      _buildSummaryCard(
                        width: cardWidth,
                        title: 'Baterai',
                        value: '${pju.batteryPercentage.toInt()}%',
                        badgeText: 'BAIK',
                        badgeColor: AppTheme.statusSuccess,
                      ),
                      // Card Tegangan
                      _buildSummaryCard(
                        width: cardWidth,
                        title: 'Tegangan',
                        value: _formatVoltage(pju.voltage),
                        badgeText: 'NORMAL',
                        badgeColor: AppTheme.secondaryBlue,
                      ),
                      // Card Panel Surya
                      _buildSummaryCard(
                        width: cardWidth,
                        title: 'Panel Surya',
                        value: 'Aktif',
                        badgeText: 'BAIK',
                        badgeColor: AppTheme.statusSuccess,
                      ),
                      // Card Koneksi
                      _buildSummaryCard(
                        width: cardWidth,
                        title: 'Koneksi',
                        value: 'Stabil',
                        badgeText: 'TERHUBUNG',
                        badgeColor: isConnected
                            ? AppTheme.statusSuccess
                            : AppTheme.statusError,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 4. KONDISI PJU
              // ==========================================
              const Text(
                'Kondisi PJU',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: pju.componentStatus.entries.map((entry) {
                    final isLast = entry.key == pju.componentStatus.keys.last;
                    final isGood = entry.value.toUpperCase() == 'BAIK';

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 11.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isGood
                                      ? AppTheme.lightGreen
                                      : const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isGood
                                        ? AppTheme.statusSuccess
                                        : AppTheme.statusError,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 14,
                            endIndent: 14,
                            color: Color(0xFFF3F4F6),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // 5. FILTER GRAFIK
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Pemantauan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _periodOptions.map((period) {
                        final isSelected = _selectedPeriod == period;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPeriod = period;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ==========================================
              // 6. GRAFIK: PERUBAHAN TEGANGAN
              // ==========================================
              _buildChartContainer(
                title: 'Perubahan Tegangan',
                unitLabel: 'V',
                chart: _buildVoltageChart(historicalData),
              ),
              const SizedBox(height: 14),

              // ==========================================
              // 6. GRAFIK: PERUBAHAN BATERAI
              // ==========================================
              _buildChartContainer(
                title: 'Perubahan Baterai',
                unitLabel: '%',
                chart: _buildBatteryChart(historicalData),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required double width,
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer({
    required String title,
    required String unitLabel,
    required Widget chart,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Satuan: $unitLabel',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 160,
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildVoltageChart(List<MonitoringData> data) {
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.voltage);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 24.0,
        maxY: 27.5,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1.0,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Color(0xFFF0F0F0),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1.0,
              getTitlesWidget: (value, meta) {
                if (value == 24.0 || value == 27.5) return const SizedBox.shrink();
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox.shrink();
                final dt = data[index].timestamp;
                String label;
                if (_selectedPeriod == 'Hari ini') {
                  label = '${dt.hour.toString().padLeft(2, '0')}:00';
                } else if (_selectedPeriod == '7 Hari') {
                  label = 'H-${data.length - index - 1}';
                  if (index == data.length - 1) label = 'Hari ini';
                } else {
                  label = '${dt.day}/${dt.month}';
                }
                return Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: const Color(0xFFF59E0B),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryChart(List<MonitoringData> data) {
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.batteryPercentage);
    }).toList();

    return LineChart(
      LineChartData(
        minY: 50.0,
        maxY: 100.0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25.0,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Color(0xFFF0F0F0),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 25.0,
              getTitlesWidget: (value, meta) {
                if (value == 50.0) return const SizedBox.shrink();
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox.shrink();
                final dt = data[index].timestamp;
                String label;
                if (_selectedPeriod == 'Hari ini') {
                  label = '${dt.hour.toString().padLeft(2, '0')}:00';
                } else if (_selectedPeriod == '7 Hari') {
                  label = 'H-${data.length - index - 1}';
                  if (index == data.length - 1) label = 'Hari ini';
                } else {
                  label = '${dt.day}/${dt.month}';
                }
                return Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppTheme.primaryGreen,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryGreen.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}
