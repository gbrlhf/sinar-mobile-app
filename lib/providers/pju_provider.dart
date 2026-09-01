import 'package:flutter/foundation.dart';
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
}
