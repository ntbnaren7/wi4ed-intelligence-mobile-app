import '../models/device_state.dart';
import '../models/appliance.dart';
import '../models/alert.dart';
import '../models/signature.dart';

/// Mock data service simulating edge API responses
class MockDataService {
  MockDataService._();
  static final instance = MockDataService._();

  /// Get current device state
  DeviceState getDeviceState() {
    return DeviceState(
      isOnline: true,
      edgeEngineRunning: true,
      syncLocked: true,
      operatingMode: 'live',
      totalPowerW: 2450,
      voltageVrms: 223.4,
      currentIrms: 11.2,
      energyKwh: 42.7,
      lastUpdate: DateTime.now().subtract(const Duration(seconds: 45)),
      deviceId: 'WI4ED-001-A3F2',
      firmwareVersion: '2.4.1',
      samplingRate: 4096,
      activeAnomaly: ActiveAnomaly(
        id: 'anom-001',
        applianceId: 'app-001',
        applianceName: 'Washing Machine',
        type: 'inrush_growth',
        severity: 'warning',
        description: 'Startup current has increased by 15% from baseline',
        detectedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    );
  }

  /// Get device state without active anomaly (for demo toggle)
  DeviceState getDeviceStateNormal() {
    return DeviceState(
      isOnline: true,
      edgeEngineRunning: true,
      syncLocked: true,
      operatingMode: 'live',
      totalPowerW: 1850,
      voltageVrms: 224.1,
      currentIrms: 8.3,
      energyKwh: 42.7,
      lastUpdate: DateTime.now().subtract(const Duration(seconds: 15)),
      deviceId: 'WI4ED-001-A3F2',
      firmwareVersion: '2.4.1',
      samplingRate: 4096,
    );
  }

  /// Get all appliances
  List<Appliance> getAppliances() {
    return [
      Appliance(
        id: 'app-001',
        name: 'Washing Machine',
        iconName: 'local_laundry_service',
        currentPowerW: 450,
        matchConfidence: 94,
        healthScore: 68,
        trendState: 'degrading',
        baseline: const BaselineFeatures(
          inrushPeakA: 11.0,
          steadyStateIrmsA: 4.1,
          cycleDurationMin: 52,
          crestFactor: 1.40,
        ),
        current: const CurrentFeatures(
          inrushPeakA: 12.4,
          steadyStateIrmsA: 4.2,
          cycleDurationMin: 45,
          crestFactor: 1.42,
        ),
        trendSeries: _generateTrendData(450, 30, trending: 'up'),
        recentAnomaly: AnomalyInfo(
          id: 'anom-001',
          type: 'inrush_growth',
          severity: 'warning',
          reason: 'Startup current increased 15% above baseline, indicating possible motor wear',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        hasActiveAnomaly: true,
      ),
      Appliance(
        id: 'app-002',
        name: 'Refrigerator',
        iconName: 'kitchen',
        currentPowerW: 120,
        matchConfidence: 98,
        healthScore: 92,
        trendState: 'stable',
        baseline: const BaselineFeatures(
          inrushPeakA: 8.5,
          steadyStateIrmsA: 1.2,
          cycleDurationMin: 35,
          crestFactor: 1.35,
        ),
        current: const CurrentFeatures(
          inrushPeakA: 8.6,
          steadyStateIrmsA: 1.2,
          cycleDurationMin: 34,
          crestFactor: 1.36,
        ),
        trendSeries: _generateTrendData(120, 30, trending: 'stable'),
        lastSeen: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Appliance(
        id: 'app-003',
        name: 'Air Conditioner',
        iconName: 'ac_unit',
        currentPowerW: 1200,
        matchConfidence: 91,
        healthScore: 85,
        trendState: 'stable',
        baseline: const BaselineFeatures(
          inrushPeakA: 25.0,
          steadyStateIrmsA: 5.5,
          cycleDurationMin: 120,
          crestFactor: 1.50,
        ),
        current: const CurrentFeatures(
          inrushPeakA: 25.8,
          steadyStateIrmsA: 5.6,
          cycleDurationMin: 118,
          crestFactor: 1.52,
        ),
        trendSeries: _generateTrendData(1200, 30, trending: 'stable'),
        lastSeen: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      Appliance(
        id: 'app-004',
        name: 'Microwave Oven',
        iconName: 'microwave',
        currentPowerW: 0,
        matchConfidence: 96,
        healthScore: 95,
        trendState: 'stable',
        baseline: const BaselineFeatures(
          inrushPeakA: 6.0,
          steadyStateIrmsA: 5.2,
          cycleDurationMin: 3,
          crestFactor: 1.38,
        ),
        current: const CurrentFeatures(
          inrushPeakA: 6.1,
          steadyStateIrmsA: 5.2,
          cycleDurationMin: 3,
          crestFactor: 1.38,
        ),
        trendSeries: _generateTrendData(800, 30, trending: 'stable'),
        lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Appliance(
        id: 'app-005',
        name: 'Water Heater',
        iconName: 'water_drop',
        currentPowerW: 680,
        matchConfidence: 89,
        healthScore: 72,
        trendState: 'degrading',
        baseline: const BaselineFeatures(
          inrushPeakA: 15.0,
          steadyStateIrmsA: 14.5,
          cycleDurationMin: 25,
          crestFactor: 1.02,
        ),
        current: const CurrentFeatures(
          inrushPeakA: 16.2,
          steadyStateIrmsA: 15.1,
          cycleDurationMin: 28,
          crestFactor: 1.05,
        ),
        trendSeries: _generateTrendData(680, 30, trending: 'up'),
        lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  /// Get alerts
  List<Alert> getAlerts() {
    return [
      Alert(
        id: 'alert-001',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        applianceId: 'app-001',
        applianceName: 'Washing Machine',
        anomalyType: 'sustained_overload',
        severity: 'critical',
        explanation: 'Motor exceeded rated current by 25% for more than 30 seconds. This indicates potential winding degradation or mechanical binding.',
        actionTaken: 'cut',
      ),
      Alert(
        id: 'alert-002',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        applianceId: 'app-003',
        applianceName: 'Air Conditioner',
        anomalyType: 'inrush_growth',
        severity: 'warning',
        explanation: 'Startup current has increased 15% from baseline. Compressor may be developing issues.',
        actionTaken: 'warn',
      ),
      Alert(
        id: 'alert-003',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        applianceId: 'app-002',
        applianceName: 'Refrigerator',
        anomalyType: 'signature_drift',
        severity: 'info',
        explanation: 'Operating pattern has shifted slightly from baseline. Recommending monitoring.',
        actionTaken: 'none',
      ),
      Alert(
        id: 'alert-004',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        applianceId: 'app-005',
        applianceName: 'Water Heater',
        anomalyType: 'duty_cycle_abnormal',
        severity: 'warning',
        explanation: 'Heating cycles are 12% longer than baseline, suggesting element degradation or thermostat issues.',
        actionTaken: 'warn',
      ),
    ];
  }

  /// Get signatures
  List<Signature> getSignatures() {
    return [
      const Signature(
        id: 'sig-001',
        name: 'Washing Machine',
        iconName: 'local_laundry_service',
        typicalPowerW: 450,
        healthScore: 68,
      ),
      const Signature(
        id: 'sig-002',
        name: 'Refrigerator',
        iconName: 'kitchen',
        typicalPowerW: 120,
        healthScore: 92,
      ),
      const Signature(
        id: 'sig-003',
        name: 'Air Conditioner',
        iconName: 'ac_unit',
        typicalPowerW: 1200,
        healthScore: 85,
      ),
      const Signature(
        id: 'sig-004',
        name: 'Microwave Oven',
        iconName: 'microwave',
        typicalPowerW: 800,
        healthScore: 95,
      ),
      const Signature(
        id: 'sig-005',
        name: 'Water Heater',
        iconName: 'water_drop',
        typicalPowerW: 680,
        healthScore: 72,
      ),
      // Unknown signature example
      const Signature(
        id: 'sig-unknown-001',
        name: 'Unknown Load',
        iconName: 'help_outline',
        typicalPowerW: 340,
        healthScore: 100,
        isUnknown: true,
        confidence: 0.67,
      ),
    ];
  }

  /// Generate mock trend data
  List<TrendPoint> _generateTrendData(
    double basePower,
    int days, {
    String trending = 'stable',
  }) {
    final List<TrendPoint> points = [];
    final now = DateTime.now();
    
    for (int i = days; i >= 0; i--) {
      double value = basePower;
      
      // Add trend
      if (trending == 'up') {
        value += (days - i) * 2;
      } else if (trending == 'down') {
        value -= (days - i) * 2;
      }
      
      // Add noise
      value += (i % 7 - 3) * 5;
      
      points.add(TrendPoint(
        timestamp: now.subtract(Duration(days: i)),
        value: value.clamp(0, double.infinity),
      ));
    }
    
    return points;
  }
}
