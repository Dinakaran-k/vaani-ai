import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

class AnimatedAiGlow extends StatefulWidget {
  const AnimatedAiGlow({
    super.key,
    required this.child,
    this.size = 220,
    this.glowColor = VaaniTheme.primary,
  });

  final Widget child;
  final double size;
  final Color glowColor;

  @override
  State<AnimatedAiGlow> createState() => _AnimatedAiGlowState();
}

class VaaniEntrance extends StatelessWidget {
  const VaaniEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 18),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final delayed = delay == Duration.zero
            ? value
            : ((value * (420 + delay.inMilliseconds) - delay.inMilliseconds) /
                    420)
                .clamp(0.0, 1.0);
        return Opacity(
          opacity: delayed,
          child: Transform.translate(
            offset:
                Offset(offset.dx * (1 - delayed), offset.dy * (1 - delayed)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _AnimatedAiGlowState extends State<AnimatedAiGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = 0.86 + _controller.value * 0.16;
        final opacity = 0.10 + _controller.value * 0.12;
        return Transform.scale(
          scale: pulse,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.glowColor.withValues(alpha: opacity),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: opacity),
                  blurRadius: 72,
                  spreadRadius: 26,
                ),
              ],
            ),
            child: Center(child: child),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class AnimatedVaaniWaveform extends StatefulWidget {
  const AnimatedVaaniWaveform({
    super.key,
    this.barCount = 7,
    this.width = 14,
    this.maxHeight = 118,
    this.minHeight = 24,
    this.spacing = 5,
    this.duration = const Duration(milliseconds: 980),
  });

  final int barCount;
  final double width;
  final double maxHeight;
  final double minHeight;
  final double spacing;
  final Duration duration;

  @override
  State<AnimatedVaaniWaveform> createState() => _AnimatedVaaniWaveformState();
}

class _AnimatedVaaniWaveformState extends State<AnimatedVaaniWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final naturalWidth =
            widget.barCount * (widget.width + widget.spacing * 2);
        final scale = constraints.maxWidth.isFinite
            ? math.min(1.0, constraints.maxWidth / naturalWidth)
            : 1.0;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < widget.barCount; index++)
                  _WaveBar(
                    width: widget.width * scale,
                    height: _heightFor(index) * scale,
                    margin: EdgeInsets.symmetric(
                      horizontal: widget.spacing * scale,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  double _heightFor(int index) {
    final phase = _controller.value * math.pi * 2;
    final offset = index * 0.74;
    final wave = (math.sin(phase + offset) + 1) / 2;
    final centerBias = 1 - ((index - (widget.barCount - 1) / 2).abs() * 0.08);
    return widget.minHeight +
        (widget.maxHeight - widget.minHeight) * wave * centerBias;
  }
}

class _WaveBar extends StatelessWidget {
  const _WaveBar({
    required this.width,
    required this.height,
    required this.margin,
  });

  final double width;
  final double height;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: VaaniTheme.aiGradient,
        borderRadius: BorderRadius.circular(width),
      ),
    );
  }
}
