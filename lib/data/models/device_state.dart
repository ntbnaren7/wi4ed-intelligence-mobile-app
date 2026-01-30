/// Active Anomaly information for real-time display
class ActiveAnomaly {
  final String id;
  final String applianceId;
  final String applianceName;
  final String type;
  final String severity;
  final String description;
  final DateTime detectedAt;

  const ActiveAnomaly({
    required this.id,
    required this.applianceId,
    required this.applianceName,
    required this.type,
    required this.severity,
    required this.description,
    required this.detectedAt,
  });

  factory ActiveAnomaly.fromJson(Map<String, dynamic> json) {
    return ActiveAnomaly(
      id: json['id'] as String,
      applianceId: json['appliance_id'] as String,
      applianceName: json['appliance_name'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      detectedAt: DateTime.parse(json['detected_at'] as String),
    );
  }
}

/// Device state from /device/state endpoint
class DeviceState {
  final bool isOnline;
  final bool edgeEngineRunning;
  final bool syncLocked;
  final String operatingMode; // 'live' | 'simulation'
  final double totalPowerW;
  final double voltageVrms;
  final double currentIrms;
  final double energyKwh;
  final DateTime lastUpdate;
  final ActiveAnomaly? activeAnomaly;
  final String deviceId;
  final String firmwareVersion;
  final int samplingRate;

  const DeviceState({
    required this.isOnline,
    required this.edgeEngineRunning,
    required this.syncLocked,
    required this.operatingMode,
    required this.totalPowerW,
    required this.voltageVrms,
    required this.currentIrms,
    required this.energyKwh,
    required this.lastUpdate,
    this.activeAnomaly,
    required this.deviceId,
    required this.firmwareVersion,
    required this.samplingRate,
  });

  factory DeviceState.fromJson(Map<String, dynamic> json) {
    return DeviceState(
      isOnline: json['is_online'] as bool,
      edgeEngineRunning: json['edge_engine_running'] as bool,
      syncLocked: json['sync_locked'] as bool,
      operatingMode: json['operating_mode'] as String,
      totalPowerW: (json['total_power_w'] as num).toDouble(),
      voltageVrms: (json['voltage_vrms'] as num).toDouble(),
      currentIrms: (json['current_irms'] as num).toDouble(),
      energyKwh: (json['energy_kwh'] as num).toDouble(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
      activeAnomaly: json['active_anomaly'] != null
          ? ActiveAnomaly.fromJson(json['active_anomaly'] as Map<String, dynamic>)
          : null,
      deviceId: json['device_id'] as String,
      firmwareVersion: json['firmware_version'] as String,
      samplingRate: json['sampling_rate'] as int,
    );
  }

  /// Get system state description
  String get systemStateText {
    if (!isOnline) return 'Offline';
    if (activeAnomaly != null) return 'Anomaly Detected';
    if (!edgeEngineRunning) return 'Engine Stopped';
    return 'System Normal';
  }

  /// Check if system is in normal operating state
  bool get isNormal => isOnline && edgeEngineRunning && activeAnomaly == null;

  /// Get time since last update as human readable
  String get lastUpdateText {
    final diff = DateTime.now().difference(lastUpdate);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
