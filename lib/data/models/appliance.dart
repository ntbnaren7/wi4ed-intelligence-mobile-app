/// Baseline electrical features for an appliance
class BaselineFeatures {
  final double inrushPeakA;
  final double steadyStateIrmsA;
  final double cycleDurationMin;
  final double crestFactor;

  const BaselineFeatures({
    required this.inrushPeakA,
    required this.steadyStateIrmsA,
    required this.cycleDurationMin,
    required this.crestFactor,
  });

  factory BaselineFeatures.fromJson(Map<String, dynamic> json) {
    return BaselineFeatures(
      inrushPeakA: (json['inrush_peak_a'] as num).toDouble(),
      steadyStateIrmsA: (json['steady_state_irms_a'] as num).toDouble(),
      cycleDurationMin: (json['cycle_duration_min'] as num).toDouble(),
      crestFactor: (json['crest_factor'] as num).toDouble(),
    );
  }
}

/// Current electrical features for an appliance
class CurrentFeatures {
  final double inrushPeakA;
  final double steadyStateIrmsA;
  final double cycleDurationMin;
  final double crestFactor;

  const CurrentFeatures({
    required this.inrushPeakA,
    required this.steadyStateIrmsA,
    required this.cycleDurationMin,
    required this.crestFactor,
  });

  factory CurrentFeatures.fromJson(Map<String, dynamic> json) {
    return CurrentFeatures(
      inrushPeakA: (json['inrush_peak_a'] as num).toDouble(),
      steadyStateIrmsA: (json['steady_state_irms_a'] as num).toDouble(),
      cycleDurationMin: (json['cycle_duration_min'] as num).toDouble(),
      crestFactor: (json['crest_factor'] as num).toDouble(),
    );
  }

  /// Calculate deviation from baseline
  FeatureDeviation deviationFrom(BaselineFeatures baseline) {
    return FeatureDeviation(
      inrushDeviation: _calcDeviation(inrushPeakA, baseline.inrushPeakA),
      steadyStateDeviation: _calcDeviation(steadyStateIrmsA, baseline.steadyStateIrmsA),
      cycleDurationDeviation: _calcDeviation(cycleDurationMin, baseline.cycleDurationMin),
      crestFactorDeviation: _calcDeviation(crestFactor, baseline.crestFactor),
    );
  }

  double _calcDeviation(double current, double baseline) {
    if (baseline == 0) return 0;
    return (current - baseline) / baseline;
  }
}

/// Feature deviation percentages
class FeatureDeviation {
  final double inrushDeviation;
  final double steadyStateDeviation;
  final double cycleDurationDeviation;
  final double crestFactorDeviation;

  const FeatureDeviation({
    required this.inrushDeviation,
    required this.steadyStateDeviation,
    required this.cycleDurationDeviation,
    required this.crestFactorDeviation,
  });

  /// Get trend indicator for a deviation value
  static String getTrendIndicator(double deviation) {
    if (deviation > 0.05) return '↑';
    if (deviation < -0.05) return '↓';
    return '↔';
  }
}

/// Trend data point for charts
class TrendPoint {
  final DateTime timestamp;
  final double value;

  const TrendPoint({
    required this.timestamp,
    required this.value,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }
}

/// Recent anomaly info for an appliance
class AnomalyInfo {
  final String id;
  final String type;
  final String severity;
  final String reason;
  final DateTime timestamp;

  const AnomalyInfo({
    required this.id,
    required this.type,
    required this.severity,
    required this.reason,
    required this.timestamp,
  });

  factory AnomalyInfo.fromJson(Map<String, dynamic> json) {
    return AnomalyInfo(
      id: json['id'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String get timeAgoText {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

/// Appliance model from /appliances endpoint
class Appliance {
  final String id;
  final String name;
  final String iconName;
  final double currentPowerW;
  final int matchConfidence; // 0-100
  final int healthScore; // 0-100
  final String trendState; // 'stable' | 'degrading' | 'improving'
  final BaselineFeatures baseline;
  final CurrentFeatures current;
  final List<TrendPoint> trendSeries;
  final AnomalyInfo? recentAnomaly;
  final DateTime? lastSeen;
  final bool hasActiveAnomaly;

  const Appliance({
    required this.id,
    required this.name,
    required this.iconName,
    required this.currentPowerW,
    required this.matchConfidence,
    required this.healthScore,
    required this.trendState,
    required this.baseline,
    required this.current,
    required this.trendSeries,
    this.recentAnomaly,
    this.lastSeen,
    this.hasActiveAnomaly = false,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String? ?? 'electrical_services',
      currentPowerW: (json['current_power_w'] as num).toDouble(),
      matchConfidence: json['match_confidence'] as int,
      healthScore: json['health_score'] as int,
      trendState: json['trend_state'] as String,
      baseline: BaselineFeatures.fromJson(json['baseline'] as Map<String, dynamic>),
      current: CurrentFeatures.fromJson(json['current'] as Map<String, dynamic>),
      trendSeries: (json['trend_series'] as List<dynamic>?)
              ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentAnomaly: json['recent_anomaly'] != null
          ? AnomalyInfo.fromJson(json['recent_anomaly'] as Map<String, dynamic>)
          : null,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
      hasActiveAnomaly: json['has_active_anomaly'] as bool? ?? false,
    );
  }

  /// Get feature deviation from baseline
  FeatureDeviation get featureDeviation => current.deviationFrom(baseline);

  /// Get trend icon
  String get trendIcon {
    switch (trendState) {
      case 'degrading':
        return '↓';
      case 'improving':
        return '↑';
      default:
        return '↔';
    }
  }

  /// Check if health is concerning
  bool get isConcerning => healthScore < 70;
}
