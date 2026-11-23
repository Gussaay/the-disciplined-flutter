import 'package:flutter_test/flutter_test.dart';
import 'package:the_disciplined/data/foods.dart';
import 'package:the_disciplined/data/trainer_plan.dart';
import 'package:the_disciplined/nutrition.dart';

void main() {
  test('food database is the real one: 113 foods, unique ids, millet present', () {
    expect(kFoods, hasLength(113));
    expect(kFoods.map((f) => f.id).toSet(), hasLength(113));
    final flour = kFoods.firstWhere((f) => f.id == 'millet_flour');
    expect(flour.kcal, 378);
    final madeeda = kFoods.firstWhere((f) => f.id == 'madeeda_dukhn');
    expect(madeeda.kcal, 105);
  });

  test('trainer plan: 21 options, breakfast 1 is 607 kcal', () {
    expect(kPlanMeals.map((m) => m.options.length).toList(), [4, 6, 5, 6]);
    expect(optionKcal(kPlanMeals[0].options[0]), 607);
    for (final meal in kPlanMeals) {
      for (final option in meal.options) {
        expect(optionKcal(option), inInclusiveRange(250, 1000));
      }
    }
    expect(kPlanRules, hasLength(5));
  });

  test('portion and totals maths matches the React edition', () {
    final chicken = kFoods.firstWhere((f) => f.id == 'chicken_breast');
    final p = portion(chicken, 200);
    expect(p['kcal'], 330);
    expect(p['protein'], 62.0);
    final t = totalsOf([p, p]);
    expect(t['kcal'], 660);
    expect(t['protein'], 124.0);
  });

  test('daily targets: gaining beats maintaining; override applies', () {
    final profile = <String, dynamic>{'weight': 57.5, 'height': 175, 'age': 30, 'activity': 'light'};
    final gain = dailyTargets({...profile, 'goal': 'gain'});
    final keep = dailyTargets({...profile, 'goal': 'maintain'});
    expect(gain['kcal']!, greaterThan(keep['kcal']!));
    expect(gain['protein'], 115); // 2 g per kg at 57.5 kg
    final over = dailyTargets({...profile, 'goal': 'gain', 'targets': {'kcal': 2800}});
    expect(over['kcal'], 2800);
  });
}
