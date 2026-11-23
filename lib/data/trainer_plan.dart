// The trainer's diet plan, ported from the React edition's
// src/data/trainerPlan.js: gain weight as muscle mass on 2,800 kcal a
// day, four home meals, one option chosen from each. The Arabic is the
// trainer's own wording. Nutrition per 100 g from standard tables —
// estimates for tracking.

class PlanFood {
  const PlanFood({required this.en, required this.ar, required this.kcal, required this.protein, required this.carbs, required this.fat, required this.sugar, required this.fiber});
  final String en;
  final String ar;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final double sugar;
  final double fiber;
}

const Map<String, PlanFood> kPer100 = {
  'egg': PlanFood(en: 'Egg', ar: 'بيض', kcal: 143, protein: 12.6, carbs: 0.7, fat: 9.5, sugar: 0.4, fiber: 0),
  'baladi': PlanFood(en: 'Baladi bread', ar: 'عيش بلدي', kcal: 265, protein: 9, carbs: 49, fat: 3.2, sugar: 2, fiber: 4),
  'qareesh': PlanFood(en: 'Cottage cheese', ar: 'جبنة قريش', kcal: 98, protein: 11, carbs: 3.4, fat: 4.3, sugar: 2.7, fiber: 0),
  'foul': PlanFood(en: 'Fava beans', ar: 'فول', kcal: 110, protein: 7.6, carbs: 19.6, fat: 0.4, sugar: 1.7, fiber: 5.4),
  'milk': PlanFood(en: 'Milk', ar: 'لبن', kcal: 61, protein: 3.2, carbs: 4.8, fat: 3.3, sugar: 5, fiber: 0),
  'cheese': PlanFood(en: 'Cheese', ar: 'جبنة', kcal: 350, protein: 22, carbs: 1, fat: 28, sugar: 0.5, fiber: 0),
  'toast': PlanFood(en: 'Toast', ar: 'توست', kcal: 265, protein: 9, carbs: 49, fat: 3.2, sugar: 5, fiber: 3),
  'chicken': PlanFood(en: 'Grilled chicken', ar: 'فراخ مشوية', kcal: 190, protein: 29, carbs: 0, fat: 7.5, sugar: 0, fiber: 0),
  'meat': PlanFood(en: 'Meat', ar: 'لحمة', kcal: 250, protein: 26, carbs: 0, fat: 15, sugar: 0, fiber: 0),
  'rice': PlanFood(en: 'Cooked rice', ar: 'رز مطبوخ', kcal: 130, protein: 2.7, carbs: 28, fat: 0.3, sugar: 0, fiber: 0.4),
  'pasta': PlanFood(en: 'Cooked pasta', ar: 'مكرونة مطبوخة', kcal: 158, protein: 5.8, carbs: 31, fat: 0.9, sugar: 0.6, fiber: 1.8),
  'fish': PlanFood(en: 'Fish', ar: 'سمك', kcal: 140, protein: 26, carbs: 0, fat: 3, sugar: 0, fiber: 0),
  'kofta': PlanFood(en: 'Kofta', ar: 'كفتة', kcal: 250, protein: 26, carbs: 2, fat: 15, sugar: 0, fiber: 0.5),
  'liver': PlanFood(en: 'Liver', ar: 'كبدة', kcal: 165, protein: 26, carbs: 4, fat: 4.4, sugar: 0, fiber: 0),
  'potatoOven': PlanFood(en: 'Oven potatoes', ar: 'بطاطس في الفرن', kcal: 110, protein: 2.5, carbs: 21, fat: 2, sugar: 1, fiber: 2),
  'potatoMash': PlanFood(en: 'Mashed potatoes', ar: 'بطاطس مهروسة', kcal: 113, protein: 2, carbs: 15, fat: 4.8, sugar: 1.5, fiber: 1.3),
  'banana': PlanFood(en: 'Banana', ar: 'موز', kcal: 89, protein: 1.1, carbs: 23, fat: 0.3, sugar: 12, fiber: 2.6),
  'peanuts': PlanFood(en: 'Peanuts', ar: 'سوداني', kcal: 567, protein: 26, carbs: 16, fat: 49, sugar: 4, fiber: 8.5),
  'orangeJuice': PlanFood(en: 'Orange juice', ar: 'عصير برتقال', kcal: 45, protein: 0.7, carbs: 10.4, fat: 0.2, sugar: 8.4, fiber: 0.2),
  'juice': PlanFood(en: 'Natural juice', ar: 'عصير طبيعي', kcal: 45, protein: 0.5, carbs: 11, fat: 0.2, sugar: 9, fiber: 0.2),
  'honey': PlanFood(en: 'Honey', ar: 'عسل', kcal: 304, protein: 0.3, carbs: 82, fat: 0, sugar: 82, fiber: 0),
  'peanutButter': PlanFood(en: 'Peanut butter', ar: 'زبدة فول سوداني', kcal: 588, protein: 25, carbs: 20, fat: 50, sugar: 9, fiber: 6),
  'yoghurt': PlanFood(en: 'Yoghurt', ar: 'زبادي', kcal: 61, protein: 3.5, carbs: 4.7, fat: 3.3, sugar: 4.7, fiber: 0),
  'cornflakes': PlanFood(en: 'Cornflakes', ar: 'كورن فليكس', kcal: 357, protein: 7, carbs: 84, fat: 0.9, sugar: 8, fiber: 3),
  'apple': PlanFood(en: 'Apple', ar: 'تفاح', kcal: 52, protein: 0.3, carbs: 14, fat: 0.2, sugar: 10, fiber: 2.4),
  'tuna': PlanFood(en: 'Tuna', ar: 'تونة', kcal: 132, protein: 28, carbs: 0, fat: 1, sugar: 0, fiber: 0),
  'salad': PlanFood(en: 'Salad', ar: 'سلطة', kcal: 20, protein: 1, carbs: 4, fat: 0.2, sugar: 2, fiber: 1.5),
  'veg': PlanFood(en: 'Vegetables', ar: 'خضار', kcal: 25, protein: 1.5, carbs: 5, fat: 0.2, sugar: 2.5, fiber: 2),
};

class PlanOption {
  const PlanOption({required this.en, required this.ar, required this.items});
  final String en;
  final String ar;
  /// [food key, grams] pairs.
  final List<List<Object>> items;
}

class PlanMeal {
  const PlanMeal({required this.id, required this.en, required this.ar, required this.options});
  final String id;
  final String en;
  final String ar;
  final List<PlanOption> options;
}

const List<PlanMeal> kPlanMeals = [
  PlanMeal(id: 'breakfast', en: 'Breakfast', ar: 'الفطار', options: [
    PlanOption(en: '3 eggs + 120 g baladi bread (2 small loaves) + 50 g cottage cheese + cucumber and tomato', ar: '3 بيضات + 120 جم عيش بلدي (رغيفان صغيران) + 50 جم جبنة قريش + خيار وطماطم', items: [['egg', 150], ['baladi', 120], ['qareesh', 50], ['veg', 100]]),
    PlanOption(en: '200 g fava beans (10 tablespoons) + 2 eggs + 90 g baladi bread', ar: '200 جم فول (10 ملاعق كبيرة) + 2 بيضة + 90 جم عيش بلدي', items: [['foul', 200], ['egg', 100], ['baladi', 90]]),
    PlanOption(en: '150 g cottage cheese + 120 g baladi bread + a banana', ar: '150 جم جبنة قريش + 120 جم عيش بلدي + موزة', items: [['qareesh', 150], ['baladi', 120], ['banana', 120]]),
    PlanOption(en: '2 eggs + 80 g cheese + 4 toast slices (120 g) + a 250 ml glass of milk', ar: '2 بيضة + 80 جم جبنة + 4 توست (120 جم) + كوب لبن 250 مل', items: [['egg', 100], ['cheese', 80], ['toast', 120], ['milk', 250]]),
  ]),
  PlanMeal(id: 'lunch', en: 'Lunch', ar: 'الغداء', options: [
    PlanOption(en: '200 g grilled chicken + 300 g cooked rice (about 20 tablespoons) + salad', ar: '200 جم فراخ مشوية + 300 جم رز مطبوخ (حوالي 20 ملعقة كبيرة) + سلطة', items: [['chicken', 200], ['rice', 300], ['salad', 100]]),
    PlanOption(en: '180 g meat + 300 g cooked pasta (about 20 tablespoons) + salad', ar: '180 جم لحمة + 300 جم مكرونة مطبوخة (حوالي 20 ملعقة) + سلطة', items: [['meat', 180], ['pasta', 300], ['salad', 100]]),
    PlanOption(en: '250 g fish + 300 g cooked rice + salad', ar: '250 جم سمك + 300 جم رز مطبوخ + سلطة', items: [['fish', 250], ['rice', 300], ['salad', 100]]),
    PlanOption(en: '200 g kofta + 350 g oven potatoes + salad', ar: '200 جم كفتة + 350 جم بطاطس في الفرن + سلطة', items: [['kofta', 200], ['potatoOven', 350], ['salad', 100]]),
    PlanOption(en: '200 g liver + 300 g rice + salad', ar: '200 جم كبدة + 300 جم رز + سلطة', items: [['liver', 200], ['rice', 300], ['salad', 100]]),
    PlanOption(en: '200 g chicken + 350 g mashed potatoes + vegetables', ar: '200 جم فراخ + 350 جم بطاطس مهروسة + خضار', items: [['chicken', 200], ['potatoMash', 350], ['veg', 100]]),
  ]),
  PlanMeal(id: 'snack', en: 'Snack', ar: 'سناك', options: [
    PlanOption(en: 'A 150 g banana + 30 g peanuts (3 tablespoons) + 250 ml orange juice', ar: 'موزة 150 جم + 30 جم سوداني (3 ملاعق) + 250 مل عصير برتقال', items: [['banana', 150], ['peanuts', 30], ['orangeJuice', 250]]),
    PlanOption(en: '250 ml milk + a banana + 20 g honey (1 tablespoon)', ar: '250 مل لبن + موزة + 20 جم عسل (ملعقة كبيرة)', items: [['milk', 250], ['banana', 120], ['honey', 20]]),
    PlanOption(en: '4 toast slices (120 g) + 30 g peanut butter (2 tablespoons) + juice', ar: '4 توست (120 جم) + 30 جم زبدة فول سوداني (ملعقتان) + عصير', items: [['toast', 120], ['peanutButter', 30], ['juice', 250]]),
    PlanOption(en: '200 g yoghurt + 40 g cornflakes + an apple', ar: '200 جم زبادي + 40 جم كورن فليكس + تفاحة', items: [['yoghurt', 200], ['cornflakes', 40], ['apple', 150]]),
    PlanOption(en: '100 g cottage cheese + 2 toast slices + a glass of natural juice', ar: '100 جم جبنة قريش + 2 توست + كوب عصير طبيعي', items: [['qareesh', 100], ['toast', 60], ['juice', 250]]),
  ]),
  PlanMeal(id: 'dinner', en: 'Dinner', ar: 'العشاء', options: [
    PlanOption(en: '3 eggs + 120 g baladi bread + 50 g cottage cheese', ar: '3 بيضات + 120 جم عيش بلدي + 50 جم جبنة قريش', items: [['egg', 150], ['baladi', 120], ['qareesh', 50]]),
    PlanOption(en: '150 g cottage cheese + 120 g baladi bread + vegetables', ar: '150 جم جبنة قريش + 120 جم عيش بلدي + خضار', items: [['qareesh', 150], ['baladi', 120], ['veg', 100]]),
    PlanOption(en: 'A drained 140 g tin of tuna + 120 g baladi bread + salad', ar: 'علبة تونة مصفاة 140 جم + 120 جم عيش بلدي + سلطة', items: [['tuna', 140], ['baladi', 120], ['salad', 100]]),
    PlanOption(en: '150 g chicken + 250 g cooked rice (about 17 tablespoons)', ar: '150 جم فراخ + 250 جم رز مطبوخ (حوالي 17 ملعقة)', items: [['chicken', 150], ['rice', 250]]),
    PlanOption(en: '200 g fava beans + 2 eggs + 100 g baladi bread', ar: '200 جم فول + 2 بيضة + 100 جم عيش بلدي', items: [['foul', 200], ['egg', 100], ['baladi', 100]]),
    PlanOption(en: '150 g cottage cheese + 300 g oven potatoes + vegetables', ar: '150 جم جبنة قريش + 300 جم بطاطس في الفرن + خضار', items: [['qareesh', 150], ['potatoOven', 300], ['veg', 100]]),
  ]),
];

const List<List<String>> kPlanRules = [
  ['Drink 3 litres of water a day', 'اشرب 3 لتر ماء يومياً'],
  ['Juice is natural, with no added sugar', 'العصير طبيعي بدون سكر إضافي'],
  ['Rice and pasta are weighed after cooking', 'وزن الرز والمكرونة بعد التسوية'],
  ['Meat and chicken are weighed after cooking', 'وزن اللحوم والفراخ بعد التسوية'],
  ['Choose one option from each meal', 'اختر وجبة واحدة من كل قسم'],
];

const int kPlanKcal = 2800;
const int kPlanWaterMl = 3000;

double _r1(double v) => (v * 10).round() / 10;

/// The foods of one option, ready to write into the food log — the same
/// maths as the React edition's optionItems().
List<Map<String, dynamic>> optionItems(PlanOption option) {
  return option.items.map((pair) {
    final ref = kPer100[pair[0]]!;
    final grams = (pair[1] as num).toDouble();
    final f = grams / 100;
    return <String, dynamic>{
      'nameEn': ref.en,
      'nameAr': ref.ar,
      'grams': grams,
      'kcal': (ref.kcal * f).round(),
      'protein': _r1(ref.protein * f),
      'carbs': _r1(ref.carbs * f),
      'fat': _r1(ref.fat * f),
      'sugar': _r1(ref.sugar * f),
      'fiber': _r1(ref.fiber * f),
    };
  }).toList();
}

/// The option's total calories.
int optionKcal(PlanOption option) =>
    optionItems(option).fold(0, (sum, item) => sum + (item['kcal'] as int));
