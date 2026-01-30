import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

/// Horizontal calendar strip for date selection with month navigation
class CalendarStrip extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? selectedStart;
  final DateTime? selectedEnd;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTimeRange>? onRangeSelected;

  const CalendarStrip({
    super.key,
    required this.initialDate,
    this.selectedStart,
    this.selectedEnd,
    required this.onDateSelected,
    this.onRangeSelected,
  });

  @override
  State<CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends State<CalendarStrip> {
  late DateTime _displayedMonth;
  late ScrollController _scrollController;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _rangeStart = widget.selectedStart;
    _rangeEnd = widget.selectedEnd;
    _scrollController = ScrollController();
    
    // Scroll to today after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    final today = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    if (_displayedMonth.year == today.year && _displayedMonth.month == today.month) {
      final dayIndex = today.day - 1;
      final scrollPosition = (dayIndex * 56.0) - (MediaQuery.of(context).size.width / 2) + 28;
      _scrollController.animateTo(
        scrollPosition.clamp(0, (daysInMonth * 56.0) - MediaQuery.of(context).size.width),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  void _onDayTap(DateTime date) {
    setState(() {
      if (_rangeStart == null || _rangeEnd != null) {
        // Start new selection
        _rangeStart = date;
        _rangeEnd = null;
      } else {
        // Complete range
        if (date.isBefore(_rangeStart!)) {
          _rangeEnd = _rangeStart;
          _rangeStart = date;
        } else {
          _rangeEnd = date;
        }
      }
    });

    widget.onDateSelected(date);
    if (_rangeStart != null && _rangeEnd != null && widget.onRangeSelected != null) {
      widget.onRangeSelected!(DateTimeRange(start: _rangeStart!, end: _rangeEnd!));
    }
  }

  bool _isInRange(DateTime date) {
    if (_rangeStart == null) return false;
    if (_rangeEnd == null) return _isSameDay(date, _rangeStart!);
    return !date.isBefore(_rangeStart!) && !date.isAfter(_rangeEnd!);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    final monthName = DateFormat('MMMM yyyy').format(_displayedMonth);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month header with navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _previousMonth,
                      icon: const Icon(Icons.chevron_left_rounded),
                      iconSize: 24,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    IconButton(
                      onPressed: _nextMonth,
                      icon: const Icon(Icons.chevron_right_rounded),
                      iconSize: 24,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Days strip
          SizedBox(
            height: 72,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final date = DateTime(_displayedMonth.year, _displayedMonth.month, index + 1);
                final dayName = DateFormat('E').format(date).substring(0, 2);
                final isSelected = _isInRange(date);
                final isToday = _isToday(date);
                
                return GestureDetector(
                  onTap: () => _onDayTap(date),
                  child: Container(
                    width: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary 
                          : isToday 
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppColors.darkBackground
                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isSelected
                                ? AppColors.darkBackground
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
