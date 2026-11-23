import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/app_controller.dart';
import '../data/gym_controller.dart';
import '../data/gym_data.dart';
import '../data/gym_photos.dart';
import '../gym_logic.dart';
import '../widgets/data_image.dart';
import 'gym_session_page.dart';

/// One tool's dashboard: its photographs (the catalogue photo, the
/// machine at Easy's gym, its instruction label), what it is, the
/// muscles it trains, how to set it up, his stats on it, and its
/// exercises — the React edition's ToolDashboard.
class ToolPage extends StatelessWidget {
  const ToolPage({super.key, required this.tool});

  final GymTool tool;

  @override
  Widget build(BuildContext context) {
    final gym = Get.find<GymController>();
    String t(String en, String ar) => L(en, ar);
    final stats = toolStats(gym.sessions, tool.exercises.map((e) => e.id).toSet());
    final photo = kToolPhotos[tool.id];
    final shots = <MapEntry<String, Map<String, String>>>[
      for (final e in tool.exercises)
        if (kGymShots[e.id] != null) MapEntry(e.id, kGymShots[e.id]!),
      if (kGymShots[tool.id] != null) MapEntry(tool.id, kGymShots[tool.id]!),
    ];
    final primary = <String>{};
    final secondary = <String>{};
    for (final e in tool.exercises) {
      final tg = kTargets[e.id];
      if (tg == null) continue;
      primary.addAll(tg.primary);
      secondary.addAll(tg.secondary);
    }
    String regionName(String id) {
      final r = kRegions[id];
      return r == null ? id : L(r[0], r[1]);
    }

    final desc = kToolDesc[tool.id];
    final setup = kToolSetup[tool.id];
    return Scaffold(
      appBar: AppBar(title: Text('${tool.icon}  ${L(tool.en, tool.ar)}'), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        if (photo != null)
          ClipRRect(borderRadius: BorderRadius.circular(12), child: DataImage(photo, height: 190, width: double.infinity)),
        for (final s in shots)
          for (final kind in ['photo', 'gym', 'label'])
            if (s.value[kind] != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    kind == 'label'
                        ? t('The instruction label on the machine', 'ملصق التعليمات على الجهاز')
                        : t('This machine at your gym', 'هذا الجهاز في صالتك'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: DataImage(s.value[kind]!, width: double.infinity)),
                ]),
              ),
        if (desc != null) ...[
          const SizedBox(height: 16),
          Text(t('About this machine', 'عن هذا الجهاز'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(L(desc[0], desc[1])),
        ],
        const SizedBox(height: 16),
        Text(t('Muscles trained', 'العضلات المدرَّبة'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final r in primary) Chip(label: Text(regionName(r))),
          for (final r in secondary.difference(primary))
            Chip(label: Text(regionName(r)), backgroundColor: Colors.grey.withValues(alpha: 0.15)),
        ]),
        if (setup != null && setup.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(t('Setting up the machine', 'ضبط الجهاز'), style: Theme.of(context).textTheme.titleMedium),
          for (var i = 0; i < setup.length; i++)
            ListTile(
              dense: true,
              leading: CircleAvatar(radius: 12, child: Text('${i + 1}', style: const TextStyle(fontSize: 11))),
              title: Text(L(setup[i][0], setup[i][1])),
            ),
        ],
        const SizedBox(height: 16),
        Text(t('Your stats on this tool', 'إحصاءاتك على هذا الجهاز'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _stat(context, '${stats.sessions}', t('sessions', 'جلسات')),
          _stat(context, '${stats.sets}', t('sets', 'مجموعات')),
          if (stats.volume > 0) _stat(context, '${stats.volume.round()} kg', t('lifted', 'مرفوع')),
          if (stats.minutes > 0) _stat(context, '${stats.minutes.round()}', t('cardio minutes', 'دقائق لياقة')),
          if (stats.km > 0) _stat(context, '${stats.km} km', t('distance', 'مسافة')),
          if (stats.lastDate != null) _stat(context, stats.lastDate!, t('last used', 'آخر استخدام')),
        ]),
        const SizedBox(height: 16),
        Text(t('Exercises', 'التمارين'), style: Theme.of(context).textTheme.titleMedium),
        for (final e in tool.exercises)
          Card(
            child: ListTile(
              title: Text(L(e.en, e.ar)),
              subtitle: Text(L(e.howEn, e.howAr)),
              trailing: FilledButton.tonal(
                onPressed: () {
                  gym.startSession(tool.en, [
                    {'id': e.id, 'unit': e.unit, 'muscle': e.muscle},
                  ]);
                  Get.to(() => const GymSessionPage());
                },
                child: Text(t('Start', 'ابدأ')),
              ),
            ),
          ),
      ]),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}
