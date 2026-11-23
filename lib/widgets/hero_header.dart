import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme.dart';
import '../data/app_controller.dart';

/// The Home hero (design-refresh phase 1, BNMB pattern): a deep pine
/// gradient with a soft gold bloom, the commitment ring, the 7-day bars,
/// and four frosted-glass stat tiles that tap through to their sections.
class HeroHeader extends GetView<AppController> {
  const HeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: Brand.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          // Gold bloom in the top corner.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                gradient: RadialGradient(
                  center: const Alignment(0.85, -1),
                  radius: 1.1,
                  colors: [
                    Brand.gold300.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _greetingRow(context),
                  const SizedBox(height: 20),
                  _ringRow(),
                  const SizedBox(height: 20),
                  _weekBars(),
                  const SizedBox(height: 20),
                  _glassTiles(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greetingRow(BuildContext context) {
    final now = DateTime.now();
    final dateLine = MaterialLocalizations.of(context).formatFullDate(now);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLine,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Obx(
                () => Text(
                  controller.userName.value.isEmpty
                      ? L('Peace be upon you', 'السلام عليكم')
                      : L(
                          'Peace be upon you, ${controller.userName.value}',
                          'السلام عليكم، ${controller.userName.value}',
                        ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        _roundButton(Icons.bar_chart_rounded, '/dashboard'),
        const SizedBox(width: 8),
        _roundButton(Icons.settings_outlined, '/settings'),
      ],
    );
  }

  Widget _roundButton(IconData icon, String route) {
    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Get.toNamed(route),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _ringRow() {
    return Row(
      children: [
        Obx(() => _CommitmentRing(value: controller.commitmentToday.value)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L('Today’s commitment', 'التزام اليوم'),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Brand.gold300,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L(
                        '${controller.streakDays.value} day streak',
                        '${controller.streakDays.value} أيام متتالية',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                L(
                  'Training, food, prayer, people and English — one place.',
                  'التمرين والغذاء والصلاة والصلة والإنجليزية — في مكان واحد.',
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekBars() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  height: 32,
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: math.max(
                      0.08,
                      controller.weekValues[i].clamp(0, 1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.weekValues[i] >= 0.6
                            ? Brand.gold300
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _glassTiles() {
    return Obx(() {
      final steps = controller.stepsToday.value;
      final kcal = controller.kcalToday.value;
      final water = controller.waterMlToday.value;
      final weight = controller.lastWeightKg.value;
      return Row(
        children: [
          _glassTile(
            icon: Icons.directions_walk,
            value: steps?.toString() ?? '—',
            label: L('Steps', 'خطوات'),
            route: '/watch',
          ),
          _glassTile(
            icon: Icons.local_fire_department,
            value: '$kcal',
            label: L(
              'of ${controller.kcalTarget.value} kcal',
              'من ${controller.kcalTarget.value} سعرة',
            ),
            route: '/food',
          ),
          _glassTile(
            icon: Icons.water_drop_outlined,
            value: water >= 1000
                ? '${(water / 1000).toStringAsFixed(1)} ${L('L', 'لتر')}'
                : '$water ${L('ml', 'مل')}',
            label: L('Water', 'الماء'),
            route: '/food',
          ),
          _glassTile(
            icon: Icons.monitor_weight_outlined,
            value: weight?.toStringAsFixed(1) ?? '—',
            label: L('kg · weight', 'كجم · الوزن'),
            route: '/weight',
          ),
        ],
      );
    });
  }

  Widget _glassTile({
    required IconData icon,
    required String value,
    required String label,
    required String route,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Material(
          color: Colors.white.withValues(alpha: 0.10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Get.toNamed(route),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Column(
                children: [
                  Icon(icon, color: Brand.gold300, size: 17),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommitmentRing extends StatelessWidget {
  const _CommitmentRing({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(132, 132),
            painter: _RingPainter(value.clamp(0, 1)),
          ),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final track = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, track);
    if (value > 0.02) {
      final arc = Paint()
        ..color = value >= 0.999 ? Brand.gold300 : Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * value,
        false,
        arc,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}
