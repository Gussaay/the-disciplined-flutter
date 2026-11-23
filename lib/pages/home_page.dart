import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme.dart';
import '../data/app_controller.dart';
import '../widgets/hero_header.dart';
import '../widgets/services_grid.dart';

class _Goal {
  const _Goal(this.route, this.icon, this.color, this.nameEn, this.nameAr);
  final String route;
  final IconData icon;
  final Color color;
  final String nameEn;
  final String nameAr;
}

const _goals = [
  _Goal('/gym', Icons.fitness_center, GoalColors.gym, 'Training', 'التمرين'),
  _Goal(
    '/food',
    Icons.restaurant_outlined,
    GoalColors.food,
    'Healthy food',
    'الغذاء الصحي',
  ),
  _Goal(
    '/prayer',
    Icons.mosque_outlined,
    GoalColors.prayer,
    'Prayer',
    'الصلاة',
  ),
  _Goal(
    '/social',
    Icons.people_outline,
    GoalColors.social,
    'Keeping in touch',
    'صلة الرحم والتواصل',
  ),
  _Goal(
    '/english',
    Icons.translate,
    GoalColors.english,
    'English',
    'اللغة الإنجليزية',
  ),
];

/// Home — the hub. Hero on top, today's goal cards, then the services
/// grid. Mirrors the React edition's Home after the design refresh.
class HomePage extends GetView<AppController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const HeroHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                for (final g in _goals) ...[
                  _goalCard(g),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                const ServicesGrid(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          const routes = ['/', '/gym', '/food', '/prayer', '/settings'];
          if (i != 0) Get.toNamed(routes[i]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: L('Home', 'الرئيسية'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center),
            label: L('Gym', 'التمرين'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_outlined),
            selectedIcon: const Icon(Icons.restaurant),
            label: L('Food', 'الغذاء'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.mosque_outlined),
            selectedIcon: const Icon(Icons.mosque),
            label: L('Prayer', 'الصلاة'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: L('Settings', 'الإعدادات'),
          ),
        ],
      ),
    );
  }

  Widget _goalCard(_Goal g) {
    return Obx(() {
      // Every card reads its own observable from the controller's
      // mirrors. (An Obx that reads no observable throws in GetX and
      // renders as a grey box in release builds — that was the blank
      // Home section in 1.2.0.)
      var progress = 0.0;
      var status = L('Nothing logged yet today', 'لم تسجل شيئاً اليوم');
      switch (g.route) {
        case '/gym':
          final week = controller.gymSessionsWeek.value;
          final trained = controller.gymTrainedToday.value;
          progress = trained ? 1.0 : (week / 3).clamp(0.0, 0.9);
          status = trained
              ? L('Trained today ✓', 'تدرّبت اليوم ✓')
              : L('$week workouts this week', '$week تمارين هذا الأسبوع');
          break;
        case '/food':
          if (controller.kcalTarget.value > 0) {
            progress = (controller.kcalToday.value / controller.kcalTarget.value)
                .clamp(0.0, 1.0);
          }
          if (controller.kcalToday.value > 0) {
            status = L(
              '${controller.kcalToday.value} of ${controller.kcalTarget.value} kcal',
              '${controller.kcalToday.value} من ${controller.kcalTarget.value} سعرة',
            );
          }
          break;
        case '/prayer':
          progress = controller.prayerScoreToday.value;
          final prayed = (progress * 5).round();
          status = L('$prayed of 5 prayers today', '$prayed من 5 صلوات اليوم');
          break;
        case '/social':
          final due = controller.socialDueCount.value;
          progress = due == 0 ? 1.0 : 0.4;
          status = due == 0
              ? L('Everyone in touch', 'الجميع على تواصل')
              : L('$due people due a call', '$due أشخاص حان التواصل معهم');
          break;
        case '/english':
          final words = controller.englishWordsStarted.value;
          progress = words == 0 ? 0.0 : (words / 30).clamp(0.0, 1.0);
          status = words == 0
              ? L('No words started yet', 'لم تبدأ كلمات بعد')
              : L('$words words started', 'بدأت $words كلمة');
          break;
      }
      return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(g.route),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: g.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(g.icon, color: g.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            L(g.nameEn, g.nameAr),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: TextStyle(
                              color: g.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          color: g.color,
                          backgroundColor: g.color.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
              ],
            ),
          ),
        ),
      );
    });
  }
}
