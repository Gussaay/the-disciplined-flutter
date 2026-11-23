import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/app_controller.dart';
import '../data/gym_controller.dart';
import '../data/gym_data.dart';
import '../data/gym_photos.dart';
import '../gym_logic.dart';
import '../widgets/data_image.dart';
import 'gym_session_page.dart';
import 'tool_page.dart';

/// Training home (milestone 3): the tool catalogue with the real
/// photographs, your usual tools first, search and muscle filter,
/// one-tap start, the weekly programmes and your history — the React
/// edition's gym screens.
class GymPage extends GetView<GymController> {
  const GymPage({super.key});

  String _t(AppController c, String en, String ar) => L(en, ar);

  ToolStats _statsFor(GymTool t) => toolStats(controller.sessions, t.exercises.map((e) => e.id).toSet());

  void _startWith(GymTool tool, GymExercise exercise) {
    controller.startSession(tool.en, [
      {'id': exercise.id, 'unit': exercise.unit, 'muscle': exercise.muscle},
    ]);
    Get.to(() => const GymSessionPage());
  }

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    final query = ''.obs;
    final muscle = RxnString();
    return Scaffold(
      appBar: AppBar(title: Text(_t(app, 'Training', 'التدريب')), backgroundColor: Colors.transparent, elevation: 0),
      body: Obx(() {
        final sessions = controller.sessions;
        final ranked = [...kTools]..sort((a, b) => _statsFor(b).sessions.compareTo(_statsFor(a).sessions));
        final usual = ranked.where((t) => _statsFor(t).sessions > 0).take(6).toList();
        var visible = ranked.where((t) {
          final q = query.value.trim().toLowerCase();
          final matchesQ = q.isEmpty ||
              t.en.toLowerCase().contains(q) ||
              t.ar.contains(q) ||
              t.exercises.any((e) => e.en.toLowerCase().contains(q) || e.ar.contains(q));
          final m = muscle.value;
          final matchesM = m == null || t.exercises.any((e) => e.muscle == m);
          return matchesQ && matchesM;
        }).toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            if (controller.active.value != null)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill),
                  title: Text(_t(app, 'Workout in progress', 'تمرين جارٍ')),
                  subtitle: Text((controller.active.value!['name'] ?? '').toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.to(() => const GymSessionPage()),
                ),
              ),
            TextField(
              decoration: InputDecoration(
                hintText: _t(app, 'Search tools and exercises…', 'ابحث في الأدوات والتمارين…'),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => query.value = v,
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ChoiceChip(label: Text(_t(app, 'All', 'الكل')), selected: muscle.value == null, onSelected: (_) => muscle.value = null),
                for (final e in kMuscles.entries)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: ChoiceChip(
                      label: Text(L(e.value[0], e.value[1])),
                      selected: muscle.value == e.key,
                      onSelected: (on) => muscle.value = on ? e.key : null,
                    ),
                  ),
              ]),
            ),
            if (usual.isNotEmpty && query.value.isEmpty && muscle.value == null) ...[
              const SizedBox(height: 16),
              Text(_t(app, 'Your usual tools', 'أدواتك المعتادة'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final t in usual)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        avatar: Text(t.icon),
                        label: Text('${L(t.en, t.ar)} · ${_statsFor(t).sessions}'),
                        onPressed: () => Get.to(() => ToolPage(tool: t)),
                      ),
                    ),
                ]),
              ),
            ],
            const SizedBox(height: 16),
            for (final t in visible) _toolCard(context, app, t),
            const SizedBox(height: 20),
            Text(_t(app, 'Weekly programmes', 'برامج أسبوعية'), style: Theme.of(context).textTheme.titleMedium),
            for (final p in kPrograms)
              Card(
                child: ExpansionTile(
                  title: Text(L(p.en, p.ar)),
                  subtitle: Text(L(p.aboutEn, p.aboutAr)),
                  children: [
                    for (final d in p.days)
                      ListTile(
                        title: Text(L(d.en, d.ar)),
                        subtitle: Text(d.exercises.map((id) => L(exerciseById(id)?.en ?? id, exerciseById(id)?.ar ?? id)).join(' · ')),
                        trailing: FilledButton.tonal(
                          onPressed: () {
                            controller.startSession(L(d.en, d.ar), [
                              for (final id in d.exercises)
                                if (exerciseById(id) != null) {'id': id, 'unit': exerciseById(id)!.unit, 'muscle': exerciseById(id)!.muscle},
                            ]);
                            Get.to(() => const GymSessionPage());
                          },
                          child: Text(_t(app, 'Start', 'ابدأ')),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(_t(app, 'History', 'السجل'), style: Theme.of(context).textTheme.titleMedium),
            if (sessions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(_t(app, 'No workouts yet. Start one above.', 'لا تمارين بعد. ابدأ تمريناً من الأعلى.')),
              ),
            for (final s in sessions.reversed.take(10))
              ListTile(
                leading: const Icon(Icons.history),
                title: Text((s['name'] ?? '').toString()),
                subtitle: Text('${s['date']} · ${sessionSets(s)} ${_t(app, 'sets', 'مجموعات')} · ${sessionVolume(s).round()} kg · ${sessionMinutes(s)} ${_t(app, 'min', 'دقيقة')}'),
              ),
          ],
        );
      }),
    );
  }

  Widget _toolCard(BuildContext context, AppController app, GymTool t) {
    final stats = _statsFor(t);
    final photo = kToolPhotos[t.id];
    final muscles = <String>{};
    for (final e in t.exercises) {
      final m = kMuscles[e.muscle];
      if (m != null) muscles.add(L(m[0], m[1]));
    }
    final startExercise = stats.perExercise.entries.isNotEmpty
        ? t.exercises.firstWhere(
            (e) => e.id == (stats.perExercise.entries.toList()..sort((a, b) => ((b.value['sets'] as int)).compareTo(a.value['sets'] as int))).first.key,
            orElse: () => t.exercises.first,
          )
        : t.exercises.first;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(() => ToolPage(tool: t)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (photo != null) DataImage(photo, height: 130, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${t.icon}  ${L(t.en, t.ar)}', style: Theme.of(context).textTheme.titleMedium),
                  Text(muscles.join(' · '), style: Theme.of(context).textTheme.bodySmall),
                  if (stats.sessions > 0)
                    Text('${stats.sessions} ${_t(app, 'sessions', 'جلسات')} · ${stats.sets} ${_t(app, 'sets', 'مجموعات')}',
                        style: Theme.of(context).textTheme.bodySmall),
                ]),
              ),
              FilledButton(
                onPressed: () => _startWith(t, startExercise),
                child: Text(_t(app, 'Start', 'ابدأ')),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
