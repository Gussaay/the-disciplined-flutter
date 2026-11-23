import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/food_page.dart';
import '../pages/home_page.dart';
import '../pages/settings_page.dart';
import '../pages/shell_page.dart';
import 'theme.dart';

/// Route names mirror the React edition's paths one-for-one, so the two
/// apps describe the same map.
abstract final class AppRoutes {
  static const home = '/';
  static const gym = '/gym';
  static const food = '/food';
  static const prayer = '/prayer';
  static const quran = '/prayer/quran';
  static const azkar = '/prayer/azkar';
  static const social = '/social';
  static const english = '/english';
  static const tasks = '/tasks';
  static const weight = '/weight';
  static const watch = '/watch';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
}

GetPage _shell(
  String name, {
  required String titleEn,
  required String titleAr,
  required String mottoEn,
  required String mottoAr,
  required Color color,
  required Color dark,
  required IconData icon,
  required String noteEn,
  required String noteAr,
}) {
  return GetPage(
    name: name,
    page: () => ShellPage(
      titleEn: titleEn,
      titleAr: titleAr,
      mottoEn: mottoEn,
      mottoAr: mottoAr,
      color: color,
      dark: dark,
      icon: icon,
      milestoneNoteEn: noteEn,
      milestoneNoteAr: noteAr,
    ),
  );
}

abstract final class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    _shell(
      AppRoutes.gym,
      titleEn: 'Training',
      titleAr: 'التمرين',
      mottoEn: 'Strong body, steady habits',
      mottoAr: 'جسد قوي وعادات ثابتة',
      color: GoalColors.gym,
      dark: const Color(0xFF9A3F16),
      icon: Icons.fitness_center,
      noteEn: 'Training tools, live sessions and the per-tool dashboards are ported in milestone 3.',
      noteAr: 'تُنقل أدوات التمرين والحصص ولوحات كل أداة في المرحلة الثالثة.',
    ),
    GetPage(name: AppRoutes.food, page: () => const FoodPage()),
    _shell(
      AppRoutes.prayer,
      titleEn: 'Prayer',
      titleAr: 'الصلاة',
      mottoEn: 'Guard your prayers',
      mottoAr: 'حافظوا على الصلوات',
      color: GoalColors.prayer,
      dark: const Color(0xFF0F3D3E),
      icon: Icons.mosque_outlined,
      noteEn: 'Prayer times and the prayer log are ported in milestone 4.',
      noteAr: 'تُنقل أوقات الصلاة وسجل الصلوات في المرحلة الرابعة.',
    ),
    _shell(
      AppRoutes.quran,
      titleEn: 'Quran',
      titleAr: 'القرآن',
      mottoEn: 'Guard your prayers',
      mottoAr: 'حافظوا على الصلوات',
      color: GoalColors.prayer,
      dark: const Color(0xFF0F3D3E),
      icon: Icons.menu_book_outlined,
      noteEn: 'The Quran reader is ported in milestone 4.',
      noteAr: 'يُنقل قارئ القرآن في المرحلة الرابعة.',
    ),
    _shell(
      AppRoutes.azkar,
      titleEn: 'Azkar',
      titleAr: 'الأذكار',
      mottoEn: 'Guard your prayers',
      mottoAr: 'حافظوا على الصلوات',
      color: GoalColors.prayer,
      dark: const Color(0xFF0F3D3E),
      icon: Icons.auto_awesome_outlined,
      noteEn: 'Morning and evening azkar are ported in milestone 4.',
      noteAr: 'تُنقل أذكار الصباح والمساء في المرحلة الرابعة.',
    ),
    _shell(
      AppRoutes.social,
      titleEn: 'Keeping in touch',
      titleAr: 'صلة الرحم والتواصل',
      mottoEn: 'Keep the ties of kinship',
      mottoAr: 'صِلوا أرحامكم',
      color: GoalColors.social,
      dark: const Color(0xFF7C2847),
      icon: Icons.people_outline,
      noteEn: 'Contacts and keep-in-touch reminders are ported in milestone 4.',
      noteAr: 'تُنقل جهات الاتصال وتذكيرات الصلة في المرحلة الرابعة.',
    ),
    _shell(
      AppRoutes.english,
      titleEn: 'English',
      titleAr: 'اللغة الإنجليزية',
      mottoEn: 'A little every day',
      mottoAr: 'قليل دائم كل يوم',
      color: GoalColors.english,
      dark: const Color(0xFF2E3C8A),
      icon: Icons.translate,
      noteEn: 'Daily English study is ported in milestone 4.',
      noteAr: 'تُنقل دراسة الإنجليزية اليومية في المرحلة الرابعة.',
    ),
    _shell(
      AppRoutes.tasks,
      titleEn: 'Tasks',
      titleAr: 'المهام',
      mottoEn: 'One thing at a time',
      mottoAr: 'خطوة بعد خطوة',
      color: GoalColors.tasks,
      dark: const Color(0xFF47307F),
      icon: Icons.checklist_outlined,
      noteEn: 'Tasks are ported in milestone 4.',
      noteAr: 'تُنقل المهام في المرحلة الرابعة.',
    ),
    _shell(
      AppRoutes.weight,
      titleEn: 'Weight and body',
      titleAr: 'الوزن والجسم',
      mottoEn: 'Measure, then improve',
      mottoAr: 'قِس ثم حسّن',
      color: GoalColors.weight,
      dark: const Color(0xFF1B4A73),
      icon: Icons.monitor_weight_outlined,
      noteEn: 'The Bluetooth scale (Chipsea frames, incl. your Yoda1) is ported in milestone 3.',
      noteAr: 'يُنقل الميزان بالبلوتوث (إطارات Chipsea، ومنها ميزانك Yoda1) في المرحلة الثالثة.',
    ),
    _shell(
      AppRoutes.watch,
      titleEn: 'My watch',
      titleAr: 'ساعتي',
      mottoEn: 'Every step counts',
      mottoAr: 'كل خطوة تُحسب',
      color: GoalColors.watch,
      dark: const Color(0xFF0A5A52),
      icon: Icons.watch_outlined,
      noteEn: 'The watch link (the GloryFit protocol for your GZCSW02) is ported in milestone 3.',
      noteAr: 'يُنقل ربط الساعة (بروتوكول GloryFit لساعتك GZCSW02) في المرحلة الثالثة.',
    ),
    _shell(
      AppRoutes.dashboard,
      titleEn: 'Dashboard',
      titleAr: 'لوحة المتابعة',
      mottoEn: 'Every goal, over time',
      mottoAr: 'كل الأهداف عبر الزمن',
      color: Brand.pine800,
      dark: Brand.pine900,
      icon: Icons.bar_chart_rounded,
      noteEn: 'Week, month and three-month views are ported in milestone 4.',
      noteAr: 'تُنقل عروض الأسبوع والشهر والثلاثة أشهر في المرحلة الرابعة.',
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}
