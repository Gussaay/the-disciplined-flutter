/// Body composition from weight, impedance, height, age and sex — a
/// port of the React edition's bodyComp.js (the open Xiaomi-scale
/// formulas published by openScale). The scale measures only weight
/// and impedance; every other number is a formula.

double _r1(double v) => (v * 10).round() / 10;
double _clamp(double v, double lo, double hi) => v < lo ? lo : (v > hi ? hi : v);

double? bmiOf(double weight, double heightCm) {
  final h = heightCm / 100;
  return h > 0 && weight > 0 ? _r1(weight / (h * h)) : null;
}

Map<String, dynamic> bodyComposition({
  required double weight,
  double? impedance,
  required double height,
  required double age,
  String sex = 'male',
}) {
  final w = weight;
  final h = height;
  final a = age;
  final female = sex == 'female';
  final out = <String, dynamic>{'weight': _r1(w), 'bmi': bmiOf(w, h)};
  final imp = impedance ?? 0;
  if (!(w > 0) || !(imp > 0)) return out;

  final lbmCoeff = (h * 9.058 / 100) * (h / 100) + w * 0.32 + 12.226 - imp * 0.0068 - a * 0.0542;
  final constant = female ? (a <= 49 ? 9.25 : 7.25) : 0.8;
  var coefficient = 1.0;
  if (!female && w < 61) coefficient = 0.98;
  if (female && w > 60) coefficient = 0.96 * (h > 160 ? 1.03 : 1);
  if (female && w < 50) coefficient = 1.02 * (h > 160 ? 1.03 : 1);
  var fat = (1 - ((lbmCoeff - constant) * coefficient) / w) * 100;
  if (fat > 63) fat = 75;
  fat = _clamp(fat, 5, 75);

  var water = (100 - fat) * 0.7;
  water = _clamp(water * (water <= 50 ? 1.02 : 0.98), 35, 75);

  var bone = ((female ? 0.245691014 : 0.18016894) - lbmCoeff * 0.05158) * -1;
  bone = bone > 2.2 ? bone + 0.1 : bone - 0.1;
  bone = _clamp(bone, 0.5, 8);

  final muscle = _clamp(w - (fat / 100) * w - bone, 10, 120);

  double visceral;
  if (female) {
    if (w > (13 - h * 0.5) * -1) {
      final sub = h * 1.45 + h * 0.1158 * h - 120;
      visceral = (w * 500) / sub - 6 + a * 0.07;
    } else {
      final sub = 0.691 + h * -0.0024 + h * -0.0024;
      visceral = (h * 0.027 - sub * w) * -1 + a * 0.07 - a;
    }
  } else if (h < w * 1.6) {
    final sub = (h * 0.4 - h * (h * 0.0826)) * -1;
    visceral = (w * 305) / (sub + 48) - 2.9 + a * 0.15;
  } else {
    final sub = 0.765 + h * -0.0015;
    visceral = (h * 0.143 - w * sub) * -1 + a * 0.15 - 5.0;
  }
  visceral = _clamp(visceral, 1, 50);

  final lean = w * (1 - fat / 100);
  final bmr = (370 + 21.6 * lean).round();
  final protein = _clamp((muscle / w) * 100 - water, 5, 32);

  out.addAll({
    'impedance': imp.round(),
    'fat': _r1(fat),
    'fatMass': _r1((fat / 100) * w),
    'water': _r1(water),
    'muscle': _r1(muscle),
    'bone': _r1(bone),
    'visceral': _r1(visceral),
    'bmr': bmr,
    'protein': _r1(protein),
    'lean': _r1(lean),
  });
  return out;
}
