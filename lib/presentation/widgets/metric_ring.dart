import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Premium semi-circular gauge - matches modern dark fitness UI
class MetricRing extends StatefulWidget {
  final double value;
  final double maxValue;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? label;
  final String? unit;
  final bool showValue;
  final bool animate;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final Widget? centerWidget;

  const MetricRing({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.size = 200,
    this.strokeWidth = 16,
    this.color,
    this.backgroundColor,
    this.label,
    this.unit,
    this.showValue = true,
    this.animate = true,
    this.valueStyle,
    this.labelStyle,
    this.centerWidget,
  });

  @override
  State<MetricRing> createState() => _MetricRingState();
}

class _MetricRingState extends State<MetricRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value / widget.maxValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MetricRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.animate) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value / widget.maxValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = widget.color ?? AppColors.primary;
    final bgColor = widget.backgroundColor ??
        (isDark ? AppColors.darkSurfaceHighlight : AppColors.lightSurfaceHighlight);

    return SizedBox(
      width: widget.size,
      height: widget.size * 0.7, // Increased height to allow arc to sit higher
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final progress = widget.animate ? _animation.value : widget.value / widget.maxValue;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Semi-circular gauge
              Positioned(
                top: 0,
                child: CustomPaint(
                  size: Size(widget.size, widget.size * 0.7),
                  painter: _SemiCircularGaugePainter(
                    progress: progress.clamp(0, 1),
                    color: color,
                    backgroundColor: bgColor,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
              ),
              // Center content - Properly centered relative to width
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: widget.centerWidget ??
                    (widget.showValue
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.value.toInt().toString(),
                                style: widget.valueStyle ??
                                    AppTypography.heroMetric.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                              ),
                              if (widget.label != null)
                                Text(
                                  widget.label!,
                                  style: widget.labelStyle ??
                                      AppTypography.caption.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                ),
                            ],
                          )
                        : const SizedBox()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SemiCircularGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _SemiCircularGaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center point is shifted up (0.85 of height) to allow space for text below
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc (180 degrees)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Progress arc with gradient
    if (progress > 0) {
      // Create gradient shader for the arc
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: math.pi,
        endAngle: math.pi * 2,
        colors: [
          color,
          Color.lerp(color, const Color(0xFFFFD700), 0.5)!, // Blend to gold
          const Color(0xFFF59E0B), // Amber/orange at end
        ],
        stops: const [0.0, 0.6, 1.0],
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        math.pi,
        math.pi * progress,
        false,
        progressPaint,
      );

      // Enhanced glow at the end tip
      if (progress > 0.05) {
        final tipAngle = math.pi + (math.pi * progress);
        final tipX = center.dx + radius * math.cos(tipAngle);
        final tipY = center.dy + radius * math.sin(tipAngle);

        // Outer glow
        final outerGlow = Paint()
          ..color = color.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
        canvas.drawCircle(Offset(tipX, tipY), strokeWidth * 1.2, outerGlow);

        // Inner bright glow
        final innerGlow = Paint()
          ..color = color.withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(Offset(tipX, tipY), strokeWidth * 0.6, innerGlow);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SemiCircularGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

/// Full circular gauge (kept for compatibility)
class FullCircleGauge extends StatelessWidget {
  final double value;
  final double maxValue;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Widget? centerWidget;

  const FullCircleGauge({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.size = 120,
    this.strokeWidth = 12,
    this.color,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gaugeColor = color ?? AppColors.primary;
    final bgColor = isDark ? AppColors.darkSurfaceHighlight : AppColors.lightSurfaceHighlight;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _FullCirclePainter(
              progress: (value / maxValue).clamp(0, 1),
              color: gaugeColor,
              backgroundColor: bgColor,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerWidget != null) centerWidget!,
        ],
      ),
    );
  }
}

class _FullCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _FullCirclePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FullCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Metric Gauge kept for backward compatibility
class MetricGauge extends StatelessWidget {
  final double value;
  final double maxValue;
  final double width;
  final double height;
  final Color? color;
  final String? label;

  const MetricGauge({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.width = 140,
    this.height = 80,
    this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return MetricRing(
      value: value,
      maxValue: maxValue,
      size: width,
      color: color,
      label: label,
    );
  }
}
