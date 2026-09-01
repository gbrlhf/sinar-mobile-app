import 'package:flutter/foundation.dart';
import '../models/monitoring_data.dart';
import '../models/pju_data.dart';

class PJUProvider extends ChangeNotifier {
  // TODO: Replace with real backend data
  PjuData _pjuData = PjuData(
    lampStatus: true,
    operationMode: OperationMode.automatic,
    batteryPercentage: 78.0,
    voltage: 25.6,
    solarPanelStatus: 'BAIK',
    connectionStatus: 'TERHUBUNG',
    componentStatus: const {
      'Panel Surya': 'BAIK',
      'Baterai': 'BAIK',
      'Lampu': 'BAIK',
      'Pengendali': 'BAIK',
    },
    updatedAt: DateTime.now(),
  );

  PjuData get pjuData => _pjuData;
  bool get lampStatus => _pjuData.lampStatus;
  OperationMode get operationMode => _pjuData.operationMode;
  double get batteryPercentage => _pjuData.batteryPercentage;
  double get voltage => _pjuData.voltage;
  String get solarPanelStatus => _pjuData.solarPanelStatus;
  String get connectionStatus => _pjuData.connectionStatus;
  Map<String, String> get componentStatus => _pjuData.componentStatus;
  DateTime get updatedAt => _pjuData.updatedAt;

  bool get isManualControlAllowed =>
      _pjuData.operationMode == OperationMode.manual;

  void setOperationMode(OperationMode mode) {
    if (_pjuData.operationMode == mode) return;

    _pjuData = _pjuData.copyWith(
      operationMode: mode,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  bool turnLampOn() {
    // Kontrol ON/OFF hanya diperbolehkan pada mode manual
    if (_pjuData.operationMode == OperationMode.automatic) {
      return false;
    }

    _pjuData = _pjuData.copyWith(
      lampStatus: true,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    return true;
  }

  bool turnLampOff() {
    // Kontrol ON/OFF hanya diperbolehkan pada mode manual
    if (_pjuData.operationMode == OperationMode.automatic) {
      return false;
    }

    _pjuData = _pjuData.copyWith(
      lampStatus: false,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    return true;
  }

  // TODO: Replace with real historical backend data
  List<MonitoringData> getHistoricalData(String period) {
    final now = DateTime.now();
    switch (period) {
      case '7 Hari':
        return [
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 6)),
            batteryPercentage: 82.0,
            voltage: 25.8,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 5)),
            batteryPercentage: 75.0,
            voltage: 25.4,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 4)),
            batteryPercentage: 88.0,
            voltage: 26.1,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 3)),
            batteryPercentage: 80.0,
            voltage: 25.7,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 2)),
            batteryPercentage: 72.0,
            voltage: 25.3,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 1)),
            batteryPercentage: 85.0,
            voltage: 26.0,
          ),
          MonitoringData(
            timestamp: now,
            batteryPercentage: _pjuData.batteryPercentage,
            voltage: _pjuData.voltage,
          ),
        ];
      case '30 Hari':
        return [
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 28)),
            batteryPercentage: 80.0,
            voltage: 25.7,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 21)),
            batteryPercentage: 76.0,
            voltage: 25.5,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 14)),
            batteryPercentage: 84.0,
            voltage: 25.9,
          ),
          MonitoringData(
            timestamp: now.subtract(const Duration(days: 7)),
            batteryPercentage: 79.0,
            voltage: 25.6,
          ),
          MonitoringData(
            timestamp: now,
            batteryPercentage: _pjuData.batteryPercentage,
            voltage: _pjuData.voltage,
          ),
        ];
      case 'Hari ini':
      default:
        return [
          MonitoringData(
            timestamp: DateTime(now.year, now.month, now.day, 0),
            batteryPercentage: 70.0,
            voltage: 25.1,
          ),
          MonitoringData(
            timestamp: DateTime(now.year, now.month, now.day, 4),
            batteryPercentage: 64.0,
            voltage: 24.8,
          ),
          MonitoringData(
            timestamp: DateTime(now.year, now.month, now.day, 8),
            batteryPercentage: 72.0,
            voltage: 25.3,
          ),
          MonitoringData(
            timestamp: DateTime(now.year, now.month, now.day, 12),
            batteryPercentage: 92.0,
            voltage: 26.5,
          ),
          MonitoringData(
            timestamp: DateTime(now.year, now.month, now.day, 16),
            batteryPercentage: 86.0,
            voltage: 26.0,
          ),
          MonitoringData(
            timestamp: DateTime(now.year, now.month, now.day, 20),
            batteryPercentage: _pjuData.batteryPercentage,
            voltage: _pjuData.voltage,
          ),
        ];
    }
  }
}
