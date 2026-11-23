import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// App-wide state for the Flutter edition.
///
/// Milestone 1: today's numbers are read from the local box using the same
/// store names as the React app ('profile', 'foodLog', 'water', 'weightLog',
/// 'watchLog'), so the data layer's shape already matches the product.
/// Live sources (watch, scale, Firestore sync) are wired in milestone 2 —
/// until then the values are whatever is stored locally, or empty.
class AppController extends GetxController {
  final box = GetStorage();

  final userName = ''.obs;

  /// Today's glass-tile numbers.
  final stepsToday = RxnInt();
  final kcalToday = 0.obs;
  final kcalTarget = 2800.obs; // the trainer's plan; profile overrides in M2
  final waterMlToday = 0.obs;
  final lastWeightKg = RxnDouble();

  /// 0..1 commitment for today and for the last 7 days (hero ring + bars).
  final commitmentToday = 0.0.obs;
  final weekValues = <double>[0, 0, 0, 0, 0, 0, 0].obs;

  /// Whole-number streak of days at >= 60% commitment.
  final streakDays = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLocal();
  }

  void loadLocal() {
    final profile = box.read<Map>('profile');
    if (profile != null) {
      userName.value = (profile['name'] ?? '').toString();
    }
    final key = _dayKey(DateTime.now());
    final watchLog = box.read<Map>('watchLog');
    final todayWatch = watchLog?[key];
    if (todayWatch is Map && todayWatch['steps'] is num) {
      stepsToday.value = (todayWatch['steps'] as num).toInt();
    }
    final water = box.read<Map>('water');
    if (water?[key] is num) waterMlToday.value = (water![key] as num).toInt();
    final weights = box.read<List>('weightLog');
    if (weights != null && weights.isNotEmpty) {
      final last = weights.last;
      if (last is Map && last['weight'] is num) {
        lastWeightKg.value = (last['weight'] as num).toDouble();
      }
    }
  }

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// Tiny bilingual helper mirroring the React app's L(en, ar): Arabic when
/// the device/app locale is Arabic, English otherwise.
String L(String en, String ar) =>
    (Get.locale?.languageCode ?? Get.deviceLocale?.languageCode) == 'ar'
    ? ar
    : en;
