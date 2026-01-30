import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Circular health ring indicator with animated fill and score display
class HealthRing extends StatefulWidget {
  final int score;
  final double size;
  final double strokeWidth;
  final bool showScore;
  final bool showLabel;
  final String? label;
  final bool animate;
  final bool showPulse;

  const HealthRing({
    super.key,
    required this.score,
    this.size = 120,
    this.strokeWidth = 10,
    this.showScore = true,
    this.showLabel = true,
    this.label,
    this.animate = true,
    this.showPulse = false,
  });

  @override
  State<HealthRing> createState() => _HealthRingState();
}

class _HealthRingState extends State<HealthRing>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  int _previousScore = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: widget.score / 100)
        .animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _progressController.forward();
    }
    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HealthRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score && widget.animate) {
      _previousScore = oldWidget.score;
      _progressAnimation = Tween<double>(
        begin: _previousScore / 100,
        end: widget.score / 100,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController
        ..reset()
        ..forward();
    }
    if (widget.showPulse && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.showPulse && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getHealthColor(widget.score);
    final glowColor = AppColors.getHealthGlow(widget.score);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_progressAnimation, _pulseAnimation]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Glow layer
              if (widget.showPulse)
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: _pulseAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              // Ring
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _HealthRingPainter(
                  progress: widget.animate
                      ? _progressAnimation.value
                      : widget.score / 100,
                  color: color,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              // Center content
              if (widget.showScore)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.score.toString(),
                      style: AppTypography.largeMetric.copyWith(
                        color: color,
                      ),
                    ),
                    if (widget.showLabel)
                      Text(
                        widget.label ?? 'Health',
                        style: AppTypography.caption,
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HealthRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _HealthRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = AppColors.surfaceLight
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = strokeWidth + 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final sweepAngle = 2 * math.pi * progress.clamp(0, 1);
      const startAngle = -math.pi / 2; // Start from top

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HealthRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Small health bar for compact displays
class HealthBar extends StatelessWidget {
  final int score;
  final double width;
  final double height;
  final bool showLabel;

  const HealthBar({
    super.key,
    required this.score,
    this.width = 100,
    this.height = 6,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getHealthColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              // Glow
              Container(
                width: width * (score / 100).clamp(0, 1),
                height: height,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              // Progress
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                width: width * (score / 100).clamp(0, 1),
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ],
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            'Health: $score',
            style: AppTypography.caption,
          ),
        ],
      ],
    );
  }
}
