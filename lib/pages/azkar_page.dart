import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../data/app_controller.dart';
import '../data/food_controller.dart';

/// Azkar (milestone 4): the categories and counts from the same
/// azkar.json the React edition reads, cached on the device; tapping
/// a dhikr counts it down. Today's progress lives in 'azkarLog'.
class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  final box = GetStorage();
  final app = Get.find<AppController>();
  List<Map<String, dynamic>>? categories;
  String? error;
  int current = 0;
  late Map<String, dynamic> counts;

  String t(String en, String ar) => L(en, ar);

  @override
  void initState() {
    super.initState();
    final log = Map<String, dynamic>.from(box.read<Map>('azkarLog') ?? {});
    final today = FoodController.dayKey(DateTime.now());
    counts = Map<String, dynamic>.from(log[today] is Map ? log[today] as Map : {});
    _load();
  }

  Future<void> _load() async {
    final cached = box.read<String>('azkarCache');
    if (cached != null) {
      _setData(cached);
      return;
    }
    try {
      final res = await http.get(Uri.parse('https://disciplined-3e309.web.app/azkar.json'));
      if (res.statusCode == 200) {
        await box.write('azkarCache', res.body);
        _setData(res.body);
      } else {
        setState(() => error = 'HTTP ${res.statusCode}');
      }
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  void _setData(String body) {
    final data = jsonDecode(body) as List;
    setState(() {
      categories = data.whereType<Map>().map((c) => Map<String, dynamic>.from(c)).toList();
    });
  }

  void _saveCounts() {
    final log = Map<String, dynamic>.from(box.read<Map>('azkarLog') ?? {});
    log[FoodController.dayKey(DateTime.now())] = counts;
    box.write('azkarLog', log);
  }

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t('Azkar', 'الأذكار')), backgroundColor: Colors.transparent, elevation: 0),
        body: Center(child: error != null ? Text('${t('Could not load the azkar', 'تعذر تحميل الأذكار')}: $error') : const CircularProgressIndicator()),
      );
    }
    final cat = categories![current];
    final items = ((cat['i'] as List?) ?? []).whereType<List>().toList();
    return Scaffold(
      appBar: AppBar(title: Text(t('Azkar', 'الأذكار')), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (var i = 0; i < categories!.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text((categories![i]['c'] ?? '').toString()),
                  selected: i == current,
                  onSelected: (_) => setState(() => current = i),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i++) _dhikrCard(context, cat, items[i], i),
      ]),
    );
  }

  Widget _dhikrCard(BuildContext context, Map<String, dynamic> cat, List item, int index) {
    final text = item.isNotEmpty ? item[0].toString() : '';
    final target = item.length > 1 && item[1] is num ? (item[1] as num).toInt() : 1;
    final key = '${cat['id']}:$index';
    final done = (counts[key] as num?)?.toInt() ?? 0;
    final left = target - done;
    return Card(
      color: left <= 0 ? Colors.green.withValues(alpha: 0.12) : null,
      child: InkWell(
        onTap: () {
          setState(() => counts[key] = (done + 1).clamp(0, target));
          _saveCounts();
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(text, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 18, height: 1.8)),
            if (item.length > 2 && item[2] is String)
              Text(item[2].toString(), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: LinearProgressIndicator(value: target == 0 ? 0 : done / target)),
              const SizedBox(width: 10),
              Text(left <= 0 ? '✓' : '$done / $target'),
              IconButton(
                icon: const Icon(Icons.restart_alt, size: 18),
                onPressed: () {
                  setState(() => counts[key] = 0);
                  _saveCounts();
                },
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
