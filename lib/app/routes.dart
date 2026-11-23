import 'package:get/get.dart';

import '../pages/azkar_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/english_page.dart';
import '../pages/food_page.dart';
import '../pages/gym_page.dart';
import '../pages/gym_session_page.dart';
import '../pages/home_page.dart';
import '../pages/prayer_page.dart';
import '../pages/quran_page.dart';
import '../pages/settings_page.dart';
import '../pages/social_page.dart';
import '../pages/tasks_page.dart';
import '../pages/watch_page.dart';
import '../pages/weight_page.dart';

/// Route names mirror the React edition's paths one-for-one, so the two
/// apps describe the same map. Every section is a real page now:
/// milestones 1–4 are complete.
abstract final class AppRoutes {
  static const home = '/';
  static const gym = '/gym';
  static const gymSession = '/gym/session';
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

abstract final class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.gym, page: () => const GymPage()),
    GetPage(name: AppRoutes.gymSession, page: () => const GymSessionPage()),
    GetPage(name: AppRoutes.food, page: () => const FoodPage()),
    GetPage(name: AppRoutes.prayer, page: () => const PrayerPage()),
    GetPage(name: AppRoutes.quran, page: () => const QuranPage()),
    GetPage(name: AppRoutes.azkar, page: () => const AzkarPage()),
    GetPage(name: AppRoutes.social, page: () => const SocialPage()),
    GetPage(name: AppRoutes.english, page: () => const EnglishPage()),
    GetPage(name: AppRoutes.tasks, page: () => const TasksPage()),
    GetPage(name: AppRoutes.weight, page: () => const WeightPage()),
    GetPage(name: AppRoutes.watch, page: () => const WatchPage()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardPage()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}
