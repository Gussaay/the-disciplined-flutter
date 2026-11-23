import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_controller.dart';
import '../data/food_controller.dart';
import '../data/words.dart';

/// English study (milestone 4): the word lists of the four levels
/// with Leitner-box spaced repetition — due reviews first, then new
/// words — the React edition's english.js rules, on the 'english'
/// store ({ level, minutes, words: {id: card}, log }).
class EnglishPage extends StatefulWidget {
  const EnglishPage({super.key});

  @override
  State<EnglishPage> createState() => _EnglishPageState();
}

class _EnglishPageState extends State<EnglishPage> {
  static const _intervals = [0, 1, 2, 4, 7, 15, 30];
  final box = GetStorage();
  final app = Get.find<AppController>();
  late Map<String, dynamic> store;
  bool flipped = false;

  String t(String en, String ar) => L(en, ar);
  String get today => FoodController.dayKey(DateTime.now());

  @override
  void initState() {
    super.initState();
    store = Map<String, dynamic>.from(box.read<Map>('english') ?? {'level': 'A2', 'words': {}, 'log': {}});
    store['words'] = Map<String, dynamic>.from(store['words'] is Map ? store['words'] as Map : {});
    store['log'] = Map<String, dynamic>.from(store['log'] is Map ? store['log'] as Map : {});
  }

  String get level => (store['level'] ?? 'A2').toString();
  Map<String, dynamic> get words => store['words'] as Map<String, dynamic>;

  String _addDays(String key, int days) {
    final d = DateTime.parse(key).add(Duration(days: days));
    return FoodController.dayKey(d);
  }

  List<WordEntry> get _queue {
    final due = <MapEntry<WordEntry, int>>[];
    for (final e in kWordLevels[level] ?? []) {
      final card = words[e.id];
      if (card is Map && card['due'] != null && card['due'].toString().compareTo(today) <= 0) {
        due.add(MapEntry(e, (card['box'] as num?)?.toInt() ?? 0));
      }
    }
    due.sort((a, b) => a.value.compareTo(b.value));
    final fresh = (kWordLevels[level] ?? []).where((e) => words[e.id] == null).take(5);
    return [...due.map((d) => d.key), ...fresh];
  }

  void _review(WordEntry w, bool known) {
    final card = Map<String, dynamic>.from(words[w.id] is Map ? words[w.id] as Map : {});
    final boxNow = known ? (((card['box'] as num?)?.toInt() ?? 0) + 1).clamp(0, _intervals.length - 1) : 1;
    card['box'] = boxNow;
    card['due'] = _addDays(today, _intervals[boxNow]);
    card['seen'] = ((card['seen'] as num?)?.toInt() ?? 0) + 1;
    setState(() {
      words[w.id] = card;
      flipped = false;
    });
    box.write('english', store);
  }

  @override
  Widget build(BuildContext context) {
    final queue = _queue;
    final known = words.values.where((v) => v is Map && ((v['box'] as num?)?.toInt() ?? 0) >= 4).length;
    return Scaffold(
      appBar: AppBar(title: Text(t('English', 'الإنجليزية')), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        Row(children: [
          Text('${t('Level', 'المستوى')}: '),
          for (final lv in ['A1', 'A2', 'B1', 'B2'])
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(lv),
                selected: level == lv,
                onSelected: (_) => setState(() => store['level'] = lv),
              ),
            ),
        ]),
        Text('${t('Words started', 'كلمات بدأت')}: ${words.length} · ${t('known well', 'متقنة')}: $known'),
        const SizedBox(height: 16),
        if (queue.isEmpty)
          Text(t('Nothing due. Come back tomorrow for the next reviews.', 'لا شيء مستحق. عد غداً للمراجعات التالية.'))
        else
          _wordCard(context, queue.first, queue.length),
        const SizedBox(height: 20),
        Text(t('Free resources', 'مصادر مجانية'), style: Theme.of(context).textTheme.titleMedium),
        for (final r in kEnglishResources)
          ListTile(
            leading: const Icon(Icons.open_in_new, size: 18),
            title: Text(r[1]),
            subtitle: Text(r[0]),
            onTap: () => launchUrl(Uri.parse(r[2]), mode: LaunchMode.externalApplication),
          ),
      ]),
    );
  }

  Widget _wordCard(BuildContext context, WordEntry w, int remaining) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('$remaining ${t('words in today\'s queue', 'كلمات في قائمة اليوم')}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(w.word, style: Theme.of(context).textTheme.headlineMedium),
          if (flipped) ...[
            const SizedBox(height: 8),
            Text(w.ar, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(w.example, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              OutlinedButton(onPressed: () => _review(w, false), child: Text(t('Still learning', 'ما زلت أتعلم'))),
              FilledButton(onPressed: () => _review(w, true), child: Text(t('I know it', 'أعرفها'))),
            ]),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: FilledButton.tonal(onPressed: () => setState(() => flipped = true), child: Text(t('Show meaning', 'أظهر المعنى'))),
            ),
        ]),
      ),
    );
  }
}
