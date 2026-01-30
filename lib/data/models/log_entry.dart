/// Data models for logging and historical usage tracking

/// Represents usage log for a single appliance on a specific day
class ApplianceLog {
  final String applianceId;
  final String applianceName;
  final String iconName;
  final double usageKwh;
  final int durationMinutes;
  final int healthScore;
  final String? anomalyType;
  final String? anomalyDescription;

  const ApplianceLog({
    required this.applianceId,
    required this.applianceName,
    required this.iconName,
    required this.usageKwh,
    required this.durationMinutes,
    required this.healthScore,
    this.anomalyType,
    this.anomalyDescription,
  });

  bool get hasAnomaly => anomalyType != null;
}

/// Represents aggregated statistics for a single day
class DailyLog {
  final DateTime date;
  final double totalKwh;
  final double peakPowerW;
  final double avgPowerW;
  final int anomalyCount;
  final List<ApplianceLog> applianceLogs;

  const DailyLog({
    required this.date,
    required this.totalKwh,
    required this.peakPowerW,
    required this.avgPowerW,
    required this.anomalyCount,
    required this.applianceLogs,
  });

  bool get hasAnomalies => anomalyCount > 0;
}

/// Represents a date range selection
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});

  int get dayCount => end.difference(start).inDays + 1;

  bool includes(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    return !normalizedDate.isBefore(normalizedStart) && 
           !normalizedDate.isAfter(normalizedEnd);
  }
}

/// Aggregated stats for a range of dates
class RangeStats {
  final DateRange range;
  final double totalKwh;
  final double avgDailyKwh;
  final double peakPowerW;
  final int totalAnomalies;
  final String? patternInsight;
  final List<DailyLog> dailyLogs;

  const RangeStats({
    required this.range,
    required this.totalKwh,
    required this.avgDailyKwh,
    required this.peakPowerW,
    required this.totalAnomalies,
    this.patternInsight,
    required this.dailyLogs,
  });
}
