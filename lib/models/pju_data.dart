enum OperationMode {
  automatic,
  manual,
}

class PjuData {
  final bool lampStatus;
  final OperationMode operationMode;
  final double batteryPercentage;
  final double voltage;
  final String solarPanelStatus;
  final String connectionStatus;
  final Map<String, String> componentStatus;
  final DateTime updatedAt;

  const PjuData({
    required this.lampStatus,
    required this.operationMode,
    required this.batteryPercentage,
    required this.voltage,
    required this.solarPanelStatus,
    required this.connectionStatus,
    required this.componentStatus,
    required this.updatedAt,
  });

  PjuData copyWith({
    bool? lampStatus,
    OperationMode? operationMode,
    double? batteryPercentage,
    double? voltage,
    String? solarPanelStatus,
    String? connectionStatus,
    Map<String, String>? componentStatus,
    DateTime? updatedAt,
  }) {
    return PjuData(
      lampStatus: lampStatus ?? this.lampStatus,
      operationMode: operationMode ?? this.operationMode,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      voltage: voltage ?? this.voltage,
      solarPanelStatus: solarPanelStatus ?? this.solarPanelStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      componentStatus: componentStatus ?? this.componentStatus,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
