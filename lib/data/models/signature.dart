/// Appliance signature model from /signatures endpoint
class Signature {
  final String id;
  final String name;
  final String iconName;
  final double typicalPowerW;
  final DateTime? lastSeen;
  final int healthScore;
  final bool isUnknown;
  final double? confidence;

  const Signature({
    required this.id,
    required this.name,
    required this.iconName,
    required this.typicalPowerW,
    this.lastSeen,
    required this.healthScore,
    this.isUnknown = false,
    this.confidence,
  });

  factory Signature.fromJson(Map<String, dynamic> json) {
    return Signature(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String? ?? 'electrical_services',
      typicalPowerW: (json['typical_power_w'] as num).toDouble(),
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
      healthScore: json['health_score'] as int? ?? 100,
      isUnknown: json['is_unknown'] as bool? ?? false,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
    );
  }

  /// Get last seen text
  String get lastSeenText {
    if (lastSeen == null) return 'Never';
    final diff = DateTime.now().difference(lastSeen!);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
