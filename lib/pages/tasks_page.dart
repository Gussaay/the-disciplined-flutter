import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/app_controller.dart';
import '../data/food_controller.dart';

/// Tasks (milestone 4): a plain list with due dates, priorities and
/// categories, bucketed overdue / today / upcoming / no date / done —
/// the React edition's tasks model, on the 'tasks' store.
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  static const _rank = {'high': 0, 'normal': 1, 'low': 2};
  static const _categories = ['personal', 'work', 'family', 'health', 'study', 'religion', 'errand'];
  final box = GetStorage();
  final app = Get.find<AppController>();
  late List<Map<String, dynamic>> tasks;

  String t(String en, String ar) => L(en, ar);
  String get today => FoodController.dayKey(DateTime.now());

  @override
  void initState() {
    super.initState();
    final list = box.read<List>('tasks');
    tasks = list == null ? [] : list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _save() => box.write('tasks', tasks);

  String _bucket(Map<String, dynamic> task) {
    if (task['done'] == true) return 'done';
    final due = (task['due'] ?? '').toString();
    if (due.isEmpty) return 'nodate';
    if (due.compareTo(today) < 0) return 'overdue';
    if (due == today) return 'today';
    return 'upcoming';
  }

  @override
  Widget build(BuildContext context) {
    final buckets = <String, List<Map<String, dynamic>>>{};
    for (final task in tasks) {
      buckets.putIfAbsent(_bucket(task), () => []).add(task);
    }
    for (final list in buckets.values) {
      list.sort((a, b) => (_rank[a['priority']] ?? 1).compareTo(_rank[b['priority']] ?? 1));
    }
    const order = [
      ['overdue', 'Overdue', 'متأخرة'],
      ['today', 'Today', 'اليوم'],
      ['upcoming', 'Upcoming', 'قادمة'],
      ['nodate', 'No date', 'بدون تاريخ'],
      ['done', 'Done', 'منجزة'],
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t('Tasks', 'المهام')), backgroundColor: Colors.transparent, elevation: 0),
      floatingActionButton: FloatingActionButton(onPressed: _addTask, child: const Icon(Icons.add)),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        if (tasks.isEmpty) Text(t('No tasks yet. Tap + to add one.', 'لا مهام بعد. اضغط + للإضافة.')),
        for (final b in order)
          if ((buckets[b[0]] ?? []).isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 4),
              child: Text(L(b[1], b[2]), style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final task in buckets[b[0]]!) _taskTile(context, task),
          ],
      ]),
    );
  }

  Widget _taskTile(BuildContext context, Map<String, dynamic> task) {
    final done = task['done'] == true;
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: done,
          onChanged: (v) {
            setState(() => task['done'] = v == true);
            _save();
          },
        ),
        title: Text(
          (task['title'] ?? '').toString(),
          style: done ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
        ),
        subtitle: Text([
          if ((task['due'] ?? '').toString().isNotEmpty) task['due'].toString(),
          if ((task['time'] ?? '').toString().isNotEmpty) task['time'].toString(),
          (task['category'] ?? '').toString(),
          if ((task['notes'] ?? '').toString().isNotEmpty) task['notes'].toString(),
        ].where((x) => x.isNotEmpty).join(' · ')),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (task['priority'] == 'high') const Icon(Icons.priority_high, color: Colors.red, size: 18),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () {
              setState(() => tasks.remove(task));
              _save();
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _addTask() async {
    final title = TextEditingController();
    final notes = TextEditingController();
    var priority = 'normal';
    var category = 'personal';
    DateTime? due;
    final ok = await Get.dialog<bool>(AlertDialog(
      title: Text(t('New task', 'مهمة جديدة')),
      content: StatefulBuilder(builder: (context, setLocal) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, decoration: InputDecoration(labelText: t('Title', 'العنوان')), autofocus: true),
          TextField(controller: notes, decoration: InputDecoration(labelText: t('Notes', 'ملاحظات'))),
          const SizedBox(height: 8),
          Row(children: [
            Text('${t('Due', 'التاريخ')}: '),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2035));
                if (picked != null) setLocal(() => due = picked);
              },
              child: Text(due == null ? t('None', 'بدون') : FoodController.dayKey(due!)),
            ),
          ]),
          Row(children: [
            DropdownButton<String>(
              value: priority,
              items: [for (final p in ['high', 'normal', 'low']) DropdownMenuItem(value: p, child: Text(p))],
              onChanged: (v) => setLocal(() => priority = v ?? 'normal'),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: category,
              items: [for (final c in _categories) DropdownMenuItem(value: c, child: Text(c))],
              onChanged: (v) => setLocal(() => category = v ?? 'personal'),
            ),
          ]),
        ]);
      }),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: Text(t('Cancel', 'إلغاء'))),
        FilledButton(onPressed: () => Get.back(result: true), child: Text(t('Add', 'إضافة'))),
      ],
    ));
    if (ok == true && title.text.trim().isNotEmpty) {
      setState(() {
        tasks.add({
          'id': DateTime.now().microsecondsSinceEpoch.toString(),
          'title': title.text.trim(),
          'notes': notes.text.trim(),
          'due': due == null ? '' : FoodController.dayKey(due!),
          'time': '',
          'priority': priority,
          'category': category,
          'done': false,
        });
      });
      _save();
    }
  }
}
