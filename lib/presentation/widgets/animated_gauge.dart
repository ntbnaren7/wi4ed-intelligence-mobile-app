import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Animated radial gauge widget for system state visualization
class AnimatedGauge extends StatefulWidget {
  final double value;
  final double maxValue;
  final String? label;
  final Color? progressColor;
  final Color? backgroundColor;
  final double size;
  final double strokeWidth;
  final Widget? centerWidget;
  final bool showGlow;
  final Duration animationDuration;

  const AnimatedGauge({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.label,
    this.progressColor,
    this.backgroundColor,
    this.size = 200,
    this.strokeWidth = 12,
    this.centerWidget,
    this.showGlow = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedGauge> createState() => _AnimatedGaugeState();
}

class _AnimatedGaugeState extends State<AnimatedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.value / widget.maxValue)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value / oldWidget.maxValue;
      _animation = Tween<double>(
        begin: _previousValue,
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
    final progressColor = widget.progressColor ?? AppColors.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _GaugePainter(
              progress: _animation.value,
              progressColor: progressColor,
              backgroundColor:
                  widget.backgroundColor ?? AppColors.surfaceLight,
              strokeWidth: widget.strokeWidth,
              showGlow: widget.showGlow,
            ),
            child: Center(
              child: widget.centerWidget ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.value.toStringAsFixed(0),
                        style: AppTypography.heroMetric,
                      ),
                      if (widget.label != null)
                        Text(
                          widget.label!,
                          style: AppTypography.caption,
                        ),
                    ],
                  ),
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;
  final bool showGlow;

  _GaugePainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.showGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Start from bottom-left, sweep 270 degrees (leaving bottom open)
    const startAngle = math.pi * 0.75; // 135 degrees
    const sweepAngle = math.pi * 1.5; // 270 degrees

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Progress arc with gradient
    final progressSweep = sweepAngle * progress.clamp(0, 1);
    
    if (progressSweep > 0) {
      // Glow effect
      if (showGlow) {
        final glowPaint = Paint()
          ..color = progressColor.withValues(alpha: 0.3)
          ..strokeWidth = strokeWidth + 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          progressSweep,
          false,
          glowPaint,
        );
      }

      // Main progress arc
      final progressPaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + progressSweep,
          colors: [
            progressColor.withValues(alpha: 0.8),
            progressColor,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        progressSweep,
        false,
        progressPaint,
      );

      // End cap glow
      if (showGlow) {
        final endAngle = startAngle + progressSweep;
        final endX = center.dx + radius * math.cos(endAngle);
        final endY = center.dy + radius * math.sin(endAngle);
        
        final capGlowPaint = Paint()
          ..color = progressColor.withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        
        canvas.drawCircle(Offset(endX, endY), strokeWidth / 2, capGlowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}

/// Small arc indicator for compact displays
class MiniArc extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;

  const MiniArc({
    super.key,
    required this.progress,
    required this.color,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MiniArcPainter(
          progress: progress,
          color: color,
        ),
      ),
    );
  }
}

class _MiniArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _MiniArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 4.0;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // Background
    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Progress
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress.clamp(0, 1),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
