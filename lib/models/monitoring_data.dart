class MonitoringData {
  final DateTime timestamp;
  final double batteryPercentage;
  final double voltage;

  const MonitoringData({
    required this.timestamp,
    required this.batteryPercentage,
    required this.voltage,
  });
}
