import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/app_controller.dart';
import '../data/watch_controller.dart';
import '../ls02.dart';

/// The watch screen (milestone 3): link the watch over Bluetooth LE,
/// read steps, battery, heart, blood pressure and oxygen, and send the
/// GloryFit controls — the React edition's Watch page.
class WatchPage extends GetView<WatchController> {
  const WatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String en, String ar) => L(en, ar);
    return Scaffold(
      appBar: AppBar(title: Text(t('Watch', 'الساعة')), backgroundColor: Colors.transparent, elevation: 0),
      body: Obx(() {
        if (!controller.connected.value) {
          return ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
            Text(t('Link your watch. Turn it on, keep it near the phone, then search.', 'اربط ساعتك. شغّلها وأبقها قرب الهاتف ثم ابحث.')),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: controller.scanning.value ? null : controller.startScan,
              icon: const Icon(Icons.search),
              label: Text(controller.scanning.value ? t('Searching…', 'جارٍ البحث…') : t('Search for watches', 'ابحث عن الساعات')),
            ),
            if (controller.status.value.isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 8), child: Text(controller.status.value)),
            const SizedBox(height: 8),
            for (final r in controller.devices)
              ListTile(
                leading: const Icon(Icons.watch),
                title: Text(r.advertisementData.advName.isNotEmpty ? r.advertisementData.advName : (r.device.platformName.isEmpty ? r.device.remoteId.toString() : r.device.platformName)),
                subtitle: Text('${r.device.remoteId} · ${r.rssi} dBm'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => controller.connectTo(r),
              ),
          ]);
        }
        return ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
          Row(children: [
            const Icon(Icons.watch, size: 28),
            const SizedBox(width: 8),
            Expanded(child: Text(controller.deviceName.value, style: Theme.of(context).textTheme.titleLarge)),
            TextButton(onPressed: controller.disconnect, child: Text(t('Disconnect', 'قطع الاتصال'))),
          ]),
          if (controller.status.value.isNotEmpty) Text(controller.status.value),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _tile(context, Icons.battery_full, t('Battery', 'البطارية'), controller.battery.value == null ? '—' : '${controller.battery.value}%'),
            _tile(context, Icons.directions_walk, t('Steps today', 'خطوات اليوم'), controller.stepsToday.value?.toString() ?? '—'),
            _tile(context, Icons.favorite, t('Heart rate', 'نبض القلب'), controller.heart.value == null ? '—' : '${controller.heart.value} bpm'),
            _tile(context, Icons.monitor_heart, t('Blood pressure', 'ضغط الدم'),
                controller.bpSys.value == null ? '—' : '${controller.bpSys.value}/${controller.bpDia.value}'),
            _tile(context, Icons.air, t('Oxygen', 'الأكسجين'), controller.spo2.value == null ? '—' : '${controller.spo2.value}%'),
          ]),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            FilledButton.tonalIcon(onPressed: controller.refreshBasics, icon: const Icon(Icons.refresh), label: Text(t('Refresh', 'تحديث'))),
            FilledButton.tonalIcon(onPressed: controller.measureHeart, icon: const Icon(Icons.favorite), label: Text(t('Measure heart', 'قياس النبض'))),
            FilledButton.tonalIcon(onPressed: controller.measureBp, icon: const Icon(Icons.monitor_heart), label: Text(t('Measure BP', 'قياس الضغط'))),
            FilledButton.tonalIcon(onPressed: controller.measureSpo2, icon: const Icon(Icons.air), label: Text(t('Measure oxygen', 'قياس الأكسجين'))),
            FilledButton.tonalIcon(onPressed: () => controller.send(Ls02Cmd.findBand()), icon: const Icon(Icons.vibration), label: Text(t('Find watch', 'ابحث عن الساعة'))),
            FilledButton.tonalIcon(onPressed: () => controller.send(Ls02Cmd.heartAutoOn()), icon: const Icon(Icons.monitor_heart_outlined), label: Text(t('All-day HR on', 'نبض طوال اليوم'))),
            FilledButton.tonalIcon(onPressed: () => controller.send(Ls02Cmd.heartAutoOff()), icon: const Icon(Icons.monitor_heart_outlined), label: Text(t('All-day HR off', 'إيقاف نبض اليوم'))),
            FilledButton.tonalIcon(
                onPressed: () => controller.send(Ls02Cmd.drinkReminder()), icon: const Icon(Icons.water_drop), label: Text(t('Drink reminder', 'تذكير بالماء'))),
            FilledButton.tonalIcon(
                onPressed: () => controller.send(Ls02Cmd.alarm()), icon: const Icon(Icons.alarm), label: Text(t('Alarm 7:00', 'منبه 7:00'))),
            FilledButton.tonalIcon(
                onPressed: () => controller.send(Ls02Cmd.shakePhotoOn()), icon: const Icon(Icons.camera_alt), label: Text(t('Shake photo on', 'تصوير بالهز'))),
            OutlinedButton.icon(
              onPressed: () async {
                final ok = await Get.dialog<bool>(AlertDialog(
                  title: Text(t('Power the watch off?', 'إطفاء الساعة؟')),
                  content: Text(t('The watch will turn off and stay off until you press its button.', 'ستنطفئ الساعة وتبقى مطفأة حتى تضغط زرها.')),
                  actions: [
                    TextButton(onPressed: () => Get.back(result: false), child: Text(t('Cancel', 'إلغاء'))),
                    FilledButton(onPressed: () => Get.back(result: true), child: Text(t('Power off', 'إطفاء'))),
                  ],
                ));
                if (ok == true) controller.send(Ls02Cmd.powerOff());
              },
              icon: const Icon(Icons.power_settings_new),
              label: Text(t('Power off', 'إطفاء')),
            ),
          ]),
          const SizedBox(height: 20),
          Text(t('Link log', 'سجل الربط'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          for (final line in controller.log.take(60))
            Text(line, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
        ]);
      }),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, String value) {
    return Container(
      width: 108,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ]),
    );
  }
}
