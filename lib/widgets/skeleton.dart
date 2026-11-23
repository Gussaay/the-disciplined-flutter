import 'package:flutter/material.dart';

/// Shimmer placeholder — the loading half of the one feedback language
/// (spinner for waits, skeleton for content), mirroring the React app's
/// Skeleton component from the design refresh.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, this.height = 96, this.radius = 12});

  final double height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.white10 : const Color(0x1A0F3D3E);
    final shine = isDark
        ? Colors.white24
        : Colors.white.withValues(alpha: 0.45);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _c.value * 2, 0),
              end: Alignment(1 + 2 * _c.value * 2, 0),
              colors: [base, shine, base],
              stops: const [0.3, 0.5, 0.7],
            ),
          ),
        );
      },
    );
  }
}
