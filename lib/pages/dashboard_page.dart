import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/app_controller.dart';
import '../data/food_controller.dart';
import '../gym_logic.dart';
import '../prayer_calc.dart';

/// The commitment dashboard (milestone 4): one score per goal for
/// today and the week's shape — the React edition's commitment()
/// rules over the same stores.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    final food = Get.find<FoodController>();
    final box = GetStorage();
    String t(String en, String ar) => L(en, ar);
    final now = DateTime.now();
    final today = FoodController.dayKey(now);

    final sessions = ((box.read<List>('gymSessions') ?? [])).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    final weeklyGoal = (food.profile['gymDays'] as num?)?.toInt() ?? 3;
    final trained = trainedOn(sessions, today);
    var weekSessions = 0;
    for (var i = 0; i < 7; i++) {
      if (trainedOn(sessions, FoodController.dayKey(now.subtract(Duration(days: i))))) weekSessions++;
    }
    final gymScore = trained ? 1.0 : (weekSessions / weeklyGoal).clamp(0.0, 0.9);

    final totals = food.totals;
    final targets = food.targets;
    final foodScore = _dayScore(totals, targets, food.entries.isNotEmpty);

    final prayerLog = Map<String, dynamic>.from(box.read<Map>('prayerLog') ?? {});
    final prayerScore = daySummary(Map<String, dynamic>.from(prayerLog[today] is Map ? prayerLog[today] as Map : {}))['score'] as double;

    final contacts = ((box.read<List>('contacts') ?? [])).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    var socialScore = 1.0;
    if (contacts.isNotEmpty) {
      var good = 0;
      for (final c in contacts) {
        final every = ((c['every'] as num?)?.toInt() ?? 7);
        final last = c['last']?.toString();
        if (last != null && last.isNotEmpty) {
          final since = DateTime.parse(today).difference(DateTime.parse(last)).inDays;
          if (every - since >= 0) good++;
        }
      }
      socialScore = good / contacts.length;
    }

    final english = Map<String, dynamic>.from(box.read<Map>('english') ?? {});
    final eWords = Map<String, dynamic>.from(english['words'] is Map ? english['words'] as Map : {});
    final reviewedToday = eWords.values.where((v) => v is Map && v['due'] != null).length;
    final englishScore = eWords.isEmpty ? 0.0 : (reviewedToday > 0 ? 1.0 : 0.0);

    final parts = <List<dynamic>>[
      ['gym', '🏋️', t('Gym', 'الرياضة'), gymScore],
      ['food', '🥗', t('Food', 'الغذاء'), foodScore],
      ['prayer', '🕌', t('Prayer', 'الصلاة'), prayerScore],
      ['social', '🤝', t('Family & friends', 'الأهل والأصدقاء'), socialScore],
      ['english', '🔤', t('English', 'الإنجليزية'), englishScore],
    ];
    final overall = parts.fold<double>(0, (s, p) => s + (p[3] as double)) / parts.length;

    return Scaffold(
      appBar: AppBar(title: Text(t('Dashboard', 'لوحة الالتزام')), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              SizedBox(
                width: 84,
                height: 84,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(value: overall, strokeWidth: 8),
                  Text('${(overall * 100).round()}%'),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  overall >= 0.8
                      ? t('A disciplined day. Keep it up.', 'يوم ملتزم. واصل.')
                      : overall >= 0.4
                          ? t('A fair day — a little more closes it.', 'يوم لا بأس به — القليل يكمله.')
                          : t('The day is still open. Start with one goal.', 'اليوم ما زال مفتوحاً. ابدأ بهدف واحد.'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        for (final p in parts)
          Card(
            child: ListTile(
              leading: Text(p[1] as String, style: const TextStyle(fontSize: 22)),
              title: Text(p[2] as String),
              subtitle: LinearProgressIndicator(value: (p[3] as double).clamp(0.0, 1.0)),
              trailing: Text('${((p[3] as double) * 100).round()}%'),
            ),
          ),
        const SizedBox(height: 16),
        Text(t('This week', 'هذا الأسبوع'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text('${t('Workouts', 'تمارين')}: $weekSessions · ${t('Calories today', 'سعرات اليوم')}: ${(totals['kcal'] ?? 0).round()} / ${(targets['kcal'] ?? 0).round()}'),
        Text('${t('Prayers today', 'صلوات اليوم')}: ${(prayerScore * 5).round()}/5 · ${t('Words started', 'كلمات بدأت')}: ${eWords.length}'),
      ]),
    );
  }

  /// A gentle food score, after the React dayScore(): full marks in
  /// the 90–110% calorie band with protein on target, partial credit
  /// for logging at all.
  double _dayScore(Map<String, double> totals, Map<String, double> targets, bool hasEntries) {
    if (!hasEntries) return 0;
    final targetKcal = targets['kcal'] ?? 0;
    final ratio = targetKcal == 0 ? 0.0 : (totals['kcal'] ?? 0) / targetKcal;
    var score = 0.4;
    if (ratio >= 0.9 && ratio <= 1.1) score += 0.35;
    final targetProtein = targets['protein'] ?? 0;
    if (targetProtein > 0 && (totals['protein'] ?? 0) >= targetProtein * 0.9) score += 0.25;
    return score.clamp(0.0, 1.0);
  }
}
