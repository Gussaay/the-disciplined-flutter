import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme.dart';
import '../data/app_controller.dart';

class ServiceItem {
  const ServiceItem({
    required this.route,
    required this.icon,
    required this.labelEn,
    required this.labelAr,
    required this.color,
  });

  final String route;
  final IconData icon;
  final String labelEn;
  final String labelAr;
  final Color color;
}

/// Every section of the app, one tap from Home — the BNMB services grid.
/// One icon language: Material line icons at a consistent size, each in
/// its goal's colour on a pale tint of the same colour.
const List<ServiceItem> kServices = [
  ServiceItem(
    route: '/gym',
    icon: Icons.fitness_center,
    labelEn: 'Gym',
    labelAr: 'التمرين',
    color: GoalColors.gym,
  ),
  ServiceItem(
    route: '/food',
    icon: Icons.restaurant_outlined,
    labelEn: 'Food',
    labelAr: 'الغذاء',
    color: GoalColors.food,
  ),
  ServiceItem(
    route: '/prayer',
    icon: Icons.mosque_outlined,
    labelEn: 'Prayer',
    labelAr: 'الصلاة',
    color: GoalColors.prayer,
  ),
  ServiceItem(
    route: '/prayer/quran',
    icon: Icons.menu_book_outlined,
    labelEn: 'Quran',
    labelAr: 'القرآن',
    color: GoalColors.prayer,
  ),
  ServiceItem(
    route: '/prayer/azkar',
    icon: Icons.auto_awesome_outlined,
    labelEn: 'Azkar',
    labelAr: 'الأذكار',
    color: GoalColors.prayer,
  ),
  ServiceItem(
    route: '/social',
    icon: Icons.people_outline,
    labelEn: 'People',
    labelAr: 'الصلة',
    color: GoalColors.social,
  ),
  ServiceItem(
    route: '/english',
    icon: Icons.translate,
    labelEn: 'English',
    labelAr: 'الإنجليزية',
    color: GoalColors.english,
  ),
  ServiceItem(
    route: '/tasks',
    icon: Icons.checklist_outlined,
    labelEn: 'Tasks',
    labelAr: 'المهام',
    color: GoalColors.tasks,
  ),
  ServiceItem(
    route: '/weight',
    icon: Icons.monitor_weight_outlined,
    labelEn: 'Weight',
    labelAr: 'الوزن',
    color: GoalColors.weight,
  ),
  ServiceItem(
    route: '/watch',
    icon: Icons.watch_outlined,
    labelEn: 'Watch',
    labelAr: 'ساعتي',
    color: GoalColors.watch,
  ),
  ServiceItem(
    route: '/dashboard',
    icon: Icons.bar_chart_rounded,
    labelEn: 'Dashboard',
    labelAr: 'لوحة المتابعة',
    color: Brand.pine800,
  ),
  ServiceItem(
    route: '/settings',
    icon: Icons.settings_outlined,
    labelEn: 'Settings',
    labelAr: 'الإعدادات',
    color: Brand.pine800,
  ),
];

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
          child: Text(
            L('All sections', 'كل الأقسام').toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kServices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.86,
          ),
          itemBuilder: (context, i) {
            final s = kServices[i];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Get.toNamed(s.route),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: s.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(s.icon, color: s.color, size: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        L(s.labelEn, s.labelAr),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
