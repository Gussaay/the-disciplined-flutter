import '../data/foods.dart';

/// Food maths, ported from the React edition's src/lib/nutrition.js:
/// daily targets from the profile, totals of what was eaten, and the
/// nutrients of a portion. A log entry is a map with the nutrient values
/// already worked out for its grams, exactly like the React app's.

double n(Object? v) => v is num ? v.toDouble() : 0;
double r1(double v) => (v * 10).round() / 10;

const List<String> kNutrients = ['kcal', 'protein', 'carbs', 'fat', 'sugar', 'fiber'];

const Map<String, double> kActivity = {
  'sedentary': 1.2,
  'light': 1.375,
  'moderate': 1.55,
  'active': 1.725,
};

/// Daily targets. BMR by Mifflin-St Jeor, times the activity factor,
/// then -20% to lose weight or +10% to gain. Protein 1.6-2 g per kg,
/// fat 27% of the calories, the rest carbohydrate. A profile 'targets'
/// map overrides individual values at the end, as in the React app.
Map<String, double> dailyTargets(Map<String, dynamic> profile) {
  final weight = n(profile['weight']) == 0 ? 70 : n(profile['weight']);
  final height = n(profile['height']) == 0 ? 170 : n(profile['height']);
  final age = n(profile['age']) == 0 ? 30 : n(profile['age']);
  final bmr = 10 * weight + 6.25 * height - 5 * age + (profile['sex'] == 'female' ? -161 : 5);
  final tdee = bmr * (kActivity[profile['activity']] ?? kActivity['light']!);
  final goal = (profile['goal'] ?? 'maintain').toString();
  final factor = goal == 'lose' ? 0.8 : goal == 'gain' ? 1.1 : 1.0;
  final kcalRaw = (tdee * factor / 10).round() * 10.0;
  final kcal = kcalRaw < 1200 ? 1200.0 : kcalRaw;
  final protein = (weight * (goal == 'maintain' ? 1.6 : 2)).roundToDouble();
  final fat = (kcal * 0.27 / 9).roundToDouble();
  final carbsRaw = (kcal - protein * 4 - fat * 9) / 4;
  final carbs = (carbsRaw < 50 ? 50.0 : carbsRaw).roundToDouble();
  final out = <String, double>{
    'kcal': kcal,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'sugar': (kcal * 0.1 / 4).roundToDouble(),
    'fiber': (kcal / 1000 * 14).roundToDouble(),
    'water': (weight * 35 / 50).round() * 50.0,
    'bmr': bmr.roundToDouble(),
    'tdee': tdee.roundToDouble(),
  };
  final over = profile['targets'];
  if (over is Map) {
    over.forEach((k, v) {
      if (v is num) out[k.toString()] = v.toDouble();
    });
  }
  return out;
}

/// Nutrients of [grams] of a food whose values are per 100 g.
Map<String, dynamic> portion(Food food, double grams) {
  final f = grams / 100;
  return <String, dynamic>{
    'grams': grams,
    'kcal': (food.kcal * f).round(),
    'protein': r1(food.protein * f),
    'carbs': r1(food.carbs * f),
    'fat': r1(food.fat * f),
    'sugar': r1(food.sugar * f),
    'fiber': r1(food.fiber * f),
  };
}

/// Sums of the main numbers over a day's entries.
Map<String, double> totalsOf(List<Map<String, dynamic>> entries) {
  final sum = <String, double>{for (final k in kNutrients) k: 0};
  for (final e in entries) {
    for (final k in kNutrients) {
      sum[k] = sum[k]! + n(e[k]);
    }
  }
  for (final k in kNutrients) {
    sum[k] = k == 'kcal' ? sum[k]!.roundToDouble() : r1(sum[k]!);
  }
  return sum;
}
