import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/app_controller.dart';
import '../data/weight_controller.dart';

/// The weight screen (milestone 3): stand on the scale and the
/// reading arrives by itself (Chipsea broadcast), settles and saves,
/// with the body composition the formulas give — the React edition's
/// Weight page, plus manual entry.
class WeightPage extends GetView<WeightController> {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String en, String ar) => L(en, ar);
    return Scaffold(
      appBar: AppBar(title: Text(t('Weight', 'الوزن')), backgroundColor: Colors.transparent, elevation: 0),
      body: Obx(() {
        final r = controller.reading.value;
        final last = controller.history.isEmpty ? null : controller.history.last;
        return ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                if (controller.encryptedSeen.value)
                  Text(
                    t('This scale encrypts its readings for its own app, so no other app can read them. Weigh in manually below.',
                        'هذا الميزان يشفّر قراءاته لتطبيقه الخاص، فلا يستطيع تطبيق آخر قراءتها. سجّل وزنك يدوياً بالأسفل.'),
                    textAlign: TextAlign.center,
                  )
                else if (r?.weight != null) ...[
                  Text('${r!.weight!.toStringAsFixed(1)} kg', style: Theme.of(context).textTheme.displaySmall),
                  Text(
                    controller.settled.value
                        ? t('Saved ✓', 'حُفظ ✓')
                        : t('Measuring… stay still', 'جارٍ القياس… ابقَ ثابتاً'),
                  ),
                  if (r.impedance != null) Text('${t('Impedance', 'المقاومة')}: ${r.impedance!.round()} Ω'),
                  if (controller.scaleName.value.isNotEmpty) Text(controller.scaleName.value, style: Theme.of(context).textTheme.bodySmall),
                ] else
                  Text(
                    controller.scanning.value
                        ? t('Listening… stand on the scale.', 'أستمع… قف على الميزان.')
                        : t('Tap weigh-in, then stand on the scale.', 'اضغط «قياس الوزن» ثم قف على الميزان.'),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: controller.scanning.value ? controller.stopScan : controller.startScan,
                  icon: Icon(controller.scanning.value ? Icons.stop : Icons.monitor_weight),
                  label: Text(controller.scanning.value ? t('Stop', 'إيقاف') : t('Weigh in', 'قياس الوزن')),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: Text(t('Enter weight manually', 'إدخال الوزن يدوياً')),
              onTap: () async {
                final c = TextEditingController();
                final ok = await Get.dialog<bool>(AlertDialog(
                  title: Text(t('Weight (kg)', 'الوزن (كجم)')),
                  content: TextField(controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true), autofocus: true),
                  actions: [
                    TextButton(onPressed: () => Get.back(result: false), child: Text(t('Cancel', 'إلغاء'))),
                    FilledButton(onPressed: () => Get.back(result: true), child: Text(t('Save', 'حفظ'))),
                  ],
                ));
                final v = double.tryParse(c.text.trim());
                if (ok == true && v != null && v > 2 && v < 300) controller.addManual(v);
              },
            ),
          ),
          if (last != null) ...[
            const SizedBox(height: 16),
            Text(t('Latest body composition', 'أحدث تركيب للجسم'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in _compEntries(last, t)) _chip(context, e.key, e.value),
            ]),
          ],
          const SizedBox(height: 16),
          Text(t('History', 'السجل'), style: Theme.of(context).textTheme.titleMedium),
          for (final h in controller.history.reversed.take(20))
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text('${(h['weight'] as num).toStringAsFixed(1)} kg'),
              subtitle: Text('${h['date']}${h['fat'] != null ? ' · ${t('fat', 'دهون')} ${h['fat']}%' : ''}'),
            ),
        ]);
      }),
    );
  }

  List<MapEntry<String, String>> _compEntries(Map<String, dynamic> h, String Function(String, String) t) {
    String v(String k, [String unit = '']) => h[k] == null ? '—' : '${h[k]}$unit';
    return [
      MapEntry(t('BMI', 'مؤشر الكتلة'), v('bmi')),
      MapEntry(t('Body fat', 'دهون الجسم'), v('fat', '%')),
      MapEntry(t('Water', 'الماء'), v('water', '%')),
      MapEntry(t('Muscle', 'العضلات'), v('muscle', ' kg')),
      MapEntry(t('Bone', 'العظام'), v('bone', ' kg')),
      MapEntry(t('Visceral fat', 'الدهون الحشوية'), v('visceral')),
      MapEntry(t('Protein', 'البروتين'), v('protein', '%')),
      MapEntry(t('BMR', 'الأيض الأساسي'), v('bmr', ' kcal')),
    ];
  }

  Widget _chip(BuildContext context, String label, String value) {
    return Container(
      width: 108,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ]),
    );
  }
}
