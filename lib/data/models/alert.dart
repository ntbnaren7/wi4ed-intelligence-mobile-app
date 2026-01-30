/// Alert/Anomaly model from /alerts endpoint
class Alert {
  final String id;
  final DateTime timestamp;
  final String applianceId;
  final String applianceName;
  final String anomalyType;
  final String severity; // 'critical' | 'warning' | 'info'
  final String explanation;
  final String actionTaken; // 'cut' | 'warn' | 'none'
  final bool isRead;

  const Alert({
    required this.id,
    required this.timestamp,
    required this.applianceId,
    required this.applianceName,
    required this.anomalyType,
    required this.severity,
    required this.explanation,
    required this.actionTaken,
    this.isRead = false,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      applianceId: json['appliance_id'] as String,
      applianceName: json['appliance_name'] as String,
      anomalyType: json['anomaly_type'] as String,
      severity: json['severity'] as String,
      explanation: json['explanation'] as String,
      actionTaken: json['action_taken'] as String,
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  /// Get human-readable anomaly type
  String get anomalyTypeDisplay {
    switch (anomalyType) {
      case 'sustained_overload':
        return 'Sustained Overload';
      case 'inrush_growth':
        return 'Inrush Growth';
      case 'duty_cycle_abnormal':
        return 'Duty Cycle Abnormal';
      case 'signature_drift':
        return 'Signature Drift';
      default:
        return anomalyType;
    }
  }

  /// Get action taken display text
  String get actionTakenDisplay {
    switch (actionTaken.toLowerCase()) {
      case 'cut':
        return 'CUT';
      case 'warn':
        return 'WARN';
      default:
        return 'NONE';
    }
  }

  /// Get time ago text
  String get timeAgoText {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  /// Check if this is a critical alert
  bool get isCritical => severity.toLowerCase() == 'critical';
}
