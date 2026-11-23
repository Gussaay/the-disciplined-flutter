import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme.dart';
import '../data/ai_coach.dart';
import '../data/app_controller.dart';
import '../data/food_controller.dart';
import '../data/foods.dart';
import '../data/trainer_plan.dart';

/// Food (milestone 2): the day's log with totals against the targets,
/// water, the trainer's plan wired into the log, and the AI coach —
/// the React edition's Food page, with its real database and plan.
class FoodPage extends GetView<FoodController> {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L('Healthy food', 'الغذاء الصحي'), style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _summaryCard(),
          const SizedBox(height: 12),
          _waterCard(),
          const SizedBox(height: 12),
          const TrainerPlanCard(),
          const SizedBox(height: 12),
          _logCard(context),
          const SizedBox(height: 12),
          const AiCoachCard(),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final t = controller.totals;
          final tg = controller.targets;
          final kcal = t['kcal']!.round();
          final target = tg['kcal']!.round();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L('Today', 'اليوم'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('$kcal', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 6),
                  Text(L('of $target kcal', 'من $target سعرة'), style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: target == 0 ? 0 : (kcal / target).clamp(0.0, 1.0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 10),
              Text(
                L(
                  'Protein ${t['protein']} of ${tg['protein']!.round()} g · Carbs ${t['carbs']} g · Fat ${t['fat']} g',
                  'بروتين ${t['protein']} من ${tg['protein']!.round()} جم · كربوهيدرات ${t['carbs']} جم · دهون ${t['fat']} جم',
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _waterCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final ml = controller.waterMl.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.water_drop_outlined, color: GoalColors.weight),
                  const SizedBox(width: 8),
                  Text(L('Water', 'الماء'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const Spacer(),
                  Text('$ml / $kPlanWaterMl ml'),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: (ml / kPlanWaterMl).clamp(0.0, 1.0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton(onPressed: () => controller.addWater(250), child: Text(L('+250 ml', '+٢٥٠ مل'))),
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: () => controller.addWater(500), child: Text(L('+500 ml', '+٥٠٠ مل'))),
                  const Spacer(),
                  TextButton(onPressed: () => controller.addWater(-250), child: Text(L('Undo', 'تراجع'))),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _logCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L('Food log', 'سجل الغذاء'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              for (final meal in kPlanMeals) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(L(meal.en, meal.ar), style: const TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: GoalColors.food),
                      tooltip: L('Add food', 'أضف طعاماً'),
                      onPressed: () => Get.to(() => FoodPickerPage(mealId: meal.id)),
                    ),
                  ],
                ),
                ...controller.entriesFor(meal.id).map(
                  (e) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(L(e['nameEn']?.toString() ?? '', e['nameAr']?.toString() ?? '')),
                    subtitle: Text('${e['grams']} g${e['source'] == 'trainer' ? L(' · from the plan', ' · من الجدول') : ''}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${e['kcal']} kcal', style: const TextStyle(fontWeight: FontWeight.w700)),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => controller.removeEntry(e['id'].toString()),
                        ),
                      ],
                    ),
                  ),
                ),
                if (controller.entriesFor(meal.id).isEmpty)
                  Text(L('Nothing logged yet', 'لا شيء بعد'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ],
          );
        }),
      ),
    );
  }
}

/// The trainer's plan: pick one option per meal and its foods land in
/// the log; tick the meal when eaten. Rules at the foot of the card.
class TrainerPlanCard extends GetView<FoodController> {
  const TrainerPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(L("Trainer's plan", 'جدول مدربك'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const Spacer(),
                  Chip(label: Text('$kPlanKcal kcal')),
                ],
              ),
              Text(
                L('One option from each meal. Choosing writes its foods into your log.', 'اختر وجبة واحدة من كل قسم، واختيارها يكتب أطعمتها في سجلك.'),
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              for (final meal in kPlanMeals) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(L(meal.en, meal.ar), style: const TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (controller.picks[meal.id] != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(L('Eaten', 'تم الأكل'), style: const TextStyle(fontSize: 13)),
                          Checkbox(
                            value: controller.eatenMeals[meal.id] ?? false,
                            onChanged: (_) => controller.toggleEaten(meal.id),
                          ),
                        ],
                      ),
                  ],
                ),
                for (var i = 0; i < meal.options.length; i++)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      controller.picks[meal.id] == i ? Icons.check_circle : Icons.circle_outlined,
                      color: controller.picks[meal.id] == i ? GoalColors.food : Colors.grey,
                    ),
                    title: Text(L(meal.options[i].en, meal.options[i].ar), style: const TextStyle(fontSize: 13.5)),
                    trailing: Text('${optionKcal(meal.options[i])} kcal', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    onTap: () => controller.choosePlanOption(meal.id, i),
                  ),
              ],
              const Divider(height: 24),
              for (final rule in kPlanRules)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(L(rule[0], rule[1]), style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// The AI coach card: one tap analyses the day against the plan.
class AiCoachCard extends StatefulWidget {
  const AiCoachCard({super.key});

  @override
  State<AiCoachCard> createState() => _AiCoachCardState();
}

class _AiCoachCardState extends State<AiCoachCard> {
  bool _busy = false;
  String? _result;
  String? _error;

  Future<void> _run() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final text = await AiCoach.analyse(Get.find<FoodController>(), arabic: (Get.locale?.languageCode ?? '') == 'ar');
      setState(() => _result = text);
    } on CoachNoKey {
      setState(() => _error = L('Add your Gemini or Groq key in Settings first; the coach uses your own key, kept on this device.', 'أضف مفتاح Gemini أو Groq من الإعدادات أولاً؛ المدرب يستخدم مفتاحك الخاص المحفوظ على جهازك.'));
    } catch (_) {
      setState(() => _error = L('The coach could not answer now. Check the connection and try again.', 'تعذر على المدرب الإجابة الآن. تحقق من الاتصال وحاول مجدداً.'));
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(L('AI coach', 'المدرب الذكي'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              L('Analyses your adherence, calories and protein against the plan.', 'يحلل التزامك وسعراتك وبروتينك مقارنة بالجدول.'),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _busy ? null : _run,
              icon: _busy
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.psychology_outlined, size: 18),
              label: Text(L('Analyse my day', 'حلل يومي')),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (_result != null) ...[
              const SizedBox(height: 12),
              SelectableText(_result!, style: const TextStyle(fontSize: 14, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Search the food database and add a portion to a meal.
class FoodPickerPage extends StatefulWidget {
  const FoodPickerPage({super.key, required this.mealId});
  final String mealId;

  @override
  State<FoodPickerPage> createState() => _FoodPickerPageState();
}

class _FoodPickerPageState extends State<FoodPickerPage> {
  String _query = '';

  List<Food> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return kFoods;
    return kFoods.where((f) => f.en.toLowerCase().contains(q) || f.ar.contains(_query.trim())).toList();
  }

  Future<void> _add(Food food) async {
    final grams = TextEditingController(text: food.servingG.round().toString());
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: Text(L(food.en, food.ar)),
        content: TextField(
          controller: grams,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: L('Grams (${food.servingEn} = ${food.servingG.round()} g)', 'الجرامات (${food.servingAr} = ${food.servingG.round()} جم)')),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text(L('Cancel', 'إلغاء'))),
          FilledButton(onPressed: () => Get.back(result: true), child: Text(L('Add', 'أضف'))),
        ],
      ),
    );
    final g = double.tryParse(grams.text) ?? 0;
    if (ok == true && g > 0) {
      Get.find<FoodController>().addFood(widget.mealId, food, g);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L('Add food', 'أضف طعاماً'), style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: Get.back),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: L('Search foods, English or Arabic', 'ابحث عن طعام، بالإنجليزية أو العربية'),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final f = _results[i];
                return ListTile(
                  title: Text(L(f.en, f.ar)),
                  subtitle: Text('${f.kcal.round()} kcal / 100 g'),
                  trailing: Text(f.servingEn),
                  onTap: () => _add(f),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
