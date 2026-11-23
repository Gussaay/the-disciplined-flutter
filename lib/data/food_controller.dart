import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../nutrition.dart';
import 'app_controller.dart';
import 'foods.dart';
import 'trainer_plan.dart';

/// Food state for the Flutter edition (milestone 2): today's log, water,
/// the trainer-plan picks and the profile, stored under the same store
/// names and shapes as the React app ('foodLog', 'water', 'trainerPlan',
/// 'profile'), so the data means the same thing in both editions.
class FoodController extends GetxController {
  final box = GetStorage();

  final entries = <Map<String, dynamic>>[].obs;
  final waterMl = 0.obs;
  final picks = <String, int>{}.obs;
  final eatenMeals = <String, bool>{}.obs;
  final profile = <String, dynamic>{}.obs;

  static String dayKey([DateTime? d]) {
    final t = d ?? DateTime.now();
    return '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
  }

  String get today => dayKey();

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  void loadAll() {
    final p = box.read<Map>('profile');
    if (p != null) profile.assignAll(Map<String, dynamic>.from(p));
    final log = box.read<Map>('foodLog');
    final day = log?[today];
    entries.assignAll(
      day is List
          ? day.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
          : <Map<String, dynamic>>[],
    );
    final water = box.read<Map>('water');
    waterMl.value = water?[today] is num ? (water![today] as num).toInt() : 0;
    final plan = box.read<Map>('trainerPlan');
    final pd = plan?[today];
    if (pd is Map) {
      final pk = pd['picks'];
      if (pk is Map) {
        picks.assignAll(pk.map((k, v) => MapEntry(k.toString(), (v as num).toInt())));
      }
      final et = pd['eaten'];
      if (et is Map) {
        eatenMeals.assignAll(et.map((k, v) => MapEntry(k.toString(), v == true)));
      }
    }
    _syncHome();
  }

  Map<String, double> get targets => dailyTargets(profile);
  Map<String, double> get totals => totalsOf(entries);

  List<Map<String, dynamic>> entriesFor(String meal) =>
      entries.where((e) => e['meal'] == meal).toList();

  void _saveLog() {
    final log = Map<String, dynamic>.from(box.read<Map>('foodLog') ?? {});
    log[today] = entries.toList();
    box.write('foodLog', log);
    _syncHome();
  }

  void _saveWater() {
    final water = Map<String, dynamic>.from(box.read<Map>('water') ?? {});
    water[today] = waterMl.value;
    box.write('water', water);
    _syncHome();
  }

  void _savePlan() {
    final plan = Map<String, dynamic>.from(box.read<Map>('trainerPlan') ?? {});
    plan[today] = {'picks': Map<String, int>.from(picks), 'eaten': Map<String, bool>.from(eatenMeals)};
    box.write('trainerPlan', plan);
  }

  void saveProfile(Map<String, dynamic> next) {
    profile.assignAll(next);
    box.write('profile', Map<String, dynamic>.from(profile));
    _syncHome();
  }

  void _syncHome() {
    if (Get.isRegistered<AppController>()) {
      final app = Get.find<AppController>();
      app.kcalToday.value = totals['kcal']!.round();
      app.kcalTarget.value = targets['kcal']!.round();
      app.waterMlToday.value = waterMl.value;
      final name = profile['name'];
      if (name is String && name.isNotEmpty) app.userName.value = name;
      final w = profile['weight'];
      if (w is num) app.lastWeightKg.value = w.toDouble();
    }
  }

  void addFood(String meal, Food food, double grams) {
    final p = portion(food, grams);
    entries.add({
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'meal': meal,
      'nameEn': food.en,
      'nameAr': food.ar,
      'foodId': food.id,
      'source': 'manual',
      ...p,
    });
    _saveLog();
  }

  void removeEntry(String id) {
    entries.removeWhere((e) => e['id'] == id);
    _saveLog();
  }

  void addWater(int ml) {
    waterMl.value = (waterMl.value + ml).clamp(0, 10000);
    _saveWater();
  }

  /// Choosing a plan option writes its foods into the log (tagged
  /// source 'trainer'); choosing a different one replaces them, and
  /// tapping the chosen option again removes them — the React behaviour.
  void choosePlanOption(String mealId, int optionIdx) {
    final meal = kPlanMeals.firstWhere((m) => m.id == mealId);
    entries.removeWhere((e) => e['source'] == 'trainer' && e['meal'] == mealId);
    if (picks[mealId] == optionIdx) {
      picks.remove(mealId);
      eatenMeals.remove(mealId);
    } else {
      picks[mealId] = optionIdx;
      for (final item in optionItems(meal.options[optionIdx])) {
        entries.add({
          'id': '${DateTime.now().microsecondsSinceEpoch}-${item['nameEn']}',
          'meal': mealId,
          'source': 'trainer',
          ...item,
        });
      }
    }
    _saveLog();
    _savePlan();
  }

  void toggleEaten(String mealId) {
    eatenMeals[mealId] = !(eatenMeals[mealId] ?? false);
    _savePlan();
  }

  /// The last 7 days' calories, oldest first, for the AI coach.
  List<int> last7DaysKcal() {
    final log = box.read<Map>('foodLog') ?? {};
    final out = <int>[];
    for (var i = 6; i >= 0; i--) {
      final key = dayKey(DateTime.now().subtract(Duration(days: i)));
      final day = log[key];
      if (day is List) {
        out.add(totalsOf(day.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList())['kcal']!.round());
      } else {
        out.add(0);
      }
    }
    return out;
  }
}
