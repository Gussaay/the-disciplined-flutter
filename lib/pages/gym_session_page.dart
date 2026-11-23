import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/app_controller.dart';
import '../data/gym_controller.dart';
import '../data/gym_data.dart';
import '../gym_logic.dart';

/// The workout in progress: tick sets off, adjust weights and reps,
/// add sets and exercises, then finish — saved under 'gymActive' as
/// you go, exactly like the React edition.
class GymSessionPage extends StatefulWidget {
  const GymSessionPage({super.key});

  @override
  State<GymSessionPage> createState() => _GymSessionPageState();
}

class _GymSessionPageState extends State<GymSessionPage> {
  final gym = Get.find<GymController>();
  final app = Get.find<AppController>();

  String t(String en, String ar) => L(en, ar);

  Map<String, dynamic>? get session => gym.active.value;

  @override
  Widget build(BuildContext context) {
    final s = session;
    if (s == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t('Workout', 'التمرين')), backgroundColor: Colors.transparent, elevation: 0),
        body: Center(child: Text(t('No workout in progress.', 'لا تمرين جارٍ.'))),
      );
    }
    final exercises = ((s['exercises'] as List?) ?? []).cast<Map<String, dynamic>>();
    return Scaffold(
      appBar: AppBar(
        title: Text((s['name'] ?? t('Workout', 'تمرين')).toString()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: t('Discard', 'تجاهل'),
            onPressed: () async {
              final ok = await Get.dialog<bool>(AlertDialog(
                title: Text(t('Discard this workout?', 'تجاهل هذا التمرين؟')),
                actions: [
                  TextButton(onPressed: () => Get.back(result: false), child: Text(t('Keep', 'احتفاظ'))),
                  FilledButton(onPressed: () => Get.back(result: true), child: Text(t('Discard', 'تجاهل'))),
                ],
              ));
              if (ok == true) {
                gym.discardActive();
                Get.back();
              }
            },
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        for (var ei = 0; ei < exercises.length; ei++) _exerciseCard(exercises[ei]),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addExercise,
          icon: const Icon(Icons.add),
          label: Text(t('Add an exercise', 'أضف تمريناً')),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            final before = sessionSets(s);
            gym.finishActive();
            Get.back();
            Get.snackbar(
              t('Workout saved', 'حُفظ التمرين'),
              '$before ${t('sets done', 'مجموعات منجزة')}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          icon: const Icon(Icons.check),
          label: Text(t('Finish workout', 'إنهاء التمرين')),
        ),
      ]),
    );
  }

  Widget _exerciseCard(Map<String, dynamic> ex) {
    final info = exerciseById((ex['exerciseId'] ?? '').toString());
    final unit = (ex['unit'] ?? 'kg').toString();
    final sets = ((ex['sets'] as List?) ?? []).cast<Map<String, dynamic>>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(info != null ? L(info.en, info.ar) : (ex['exerciseId'] ?? '').toString(),
              style: Theme.of(context).textTheme.titleMedium),
          if (info != null)
            Text(L(info.howEn, info.howAr), style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          for (var si = 0; si < sets.length; si++) _setRow(ex, sets[si], si, unit),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  final blank = blankSet(unit);
                  if (sets.isNotEmpty && sets.last.containsKey('weight')) {
                    blank['weight'] = sets.last['weight'];
                    blank['reps'] = sets.last['reps'];
                  }
                  sets.add(blank);
                });
                gym.persistActive();
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(t('Add set', 'أضف مجموعة')),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _setRow(Map<String, dynamic> ex, Map<String, dynamic> set, int index, String unit) {
    Widget numField(String key, String label) {
      return SizedBox(
        width: 76,
        child: TextFormField(
          initialValue: '${set[key] ?? ''}',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: label, isDense: true),
          onChanged: (v) {
            set[key] = v;
            gym.persistActive();
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 26, child: Text('${index + 1}')),
        if (unit == 'cardio') ...[
          numField('minutes', t('min', 'دقائق')),
          const SizedBox(width: 8),
          numField('km', 'km'),
        ] else if (unit == 'time') ...[
          numField('seconds', t('sec', 'ثوانٍ')),
        ] else ...[
          numField('weight', 'kg'),
          const SizedBox(width: 8),
          numField('reps', t('reps', 'تكرار')),
        ],
        const Spacer(),
        Checkbox(
          value: set['done'] == true,
          onChanged: (v) {
            setState(() => set['done'] = v == true);
            gym.persistActive();
          },
        ),
        Text(t('done', 'تم')),
      ]),
    );
  }

  Future<void> _addExercise() async {
    final picked = await Get.dialog<GymExercise>(
      AlertDialog(
        title: Text(t('Add an exercise', 'أضف تمريناً')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final tool in kTools)
                ExpansionTile(
                  title: Text('${tool.icon}  ${L(tool.en, tool.ar)}'),
                  children: [
                    for (final e in tool.exercises)
                      ListTile(title: Text(L(e.en, e.ar)), onTap: () => Get.back(result: e)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) {
      gym.addExerciseToActive({'id': picked.id, 'unit': picked.unit, 'muscle': picked.muscle});
      setState(() {});
    }
  }
}
