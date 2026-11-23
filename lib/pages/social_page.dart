import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_controller.dart';
import '../data/food_controller.dart';

/// Keeping in touch (milestone 4): contacts with a rhythm (every N
/// days), who is due or overdue, and one-tap logging — the React
/// edition's social.js rules, on the 'contacts' store.
class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final box = GetStorage();
  final app = Get.find<AppController>();
  late List<Map<String, dynamic>> contacts;

  String t(String en, String ar) => L(en, ar);
  String get today => FoodController.dayKey(DateTime.now());

  @override
  void initState() {
    super.initState();
    final list = box.read<List>('contacts');
    contacts = list == null ? [] : list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _save() => box.write('contacts', contacts);

  Map<String, dynamic> _dueInfo(Map<String, dynamic> c) {
    final every = ((c['every'] as num?)?.toInt() ?? 7) < 1 ? 7 : (c['every'] as num).toInt();
    final last = c['last']?.toString();
    if (last == null || last.isEmpty) return {'status': 'never', 'left': 0, 'every': every};
    final since = DateTime.parse(today).difference(DateTime.parse(last)).inDays;
    final left = every - since;
    final soonBand = (every / 5).round() < 1 ? 1 : (every / 5).round();
    final status = left < 0 ? 'overdue' : left == 0 ? 'due' : left <= soonBand ? 'soon' : 'ok';
    return {'status': status, 'left': left, 'every': every, 'since': since};
  }

  List<Map<String, dynamic>> get _sorted {
    const order = {'overdue': 0, 'never': 1, 'due': 2, 'soon': 3, 'ok': 4};
    final copy = [...contacts];
    copy.sort((a, b) {
      final ia = _dueInfo(a);
      final ib = _dueInfo(b);
      final byStatus = (order[ia['status']] as int).compareTo(order[ib['status']] as int);
      if (byStatus != 0) return byStatus;
      return ((ia['left'] as int) / (ia['every'] as int)).compareTo((ib['left'] as int) / (ib['every'] as int));
    });
    return copy;
  }

  void _logContact(Map<String, dynamic> c, String type) {
    setState(() {
      final history = [
        {'date': today, 'type': type},
        ...((c['history'] as List?) ?? []),
      ].take(50).toList();
      c['history'] = history;
      if (c['last'] == null || today.compareTo(c['last'].toString()) > 0) c['last'] = today;
    });
    _save();
  }

  String _statusText(Map<String, dynamic> info) {
    switch (info['status']) {
      case 'never':
        return t('Not contacted yet', 'لم تتواصل بعد');
      case 'overdue':
        return '${t('Overdue by', 'متأخر')} ${-(info['left'] as int)} ${t('days', 'أيام')}';
      case 'due':
        return t('Due today', 'مستحق اليوم');
      case 'soon':
        return '${t('In', 'بعد')} ${info['left']} ${t('days', 'أيام')}';
      default:
        return '${t('In touch · next in', 'على تواصل · التالي بعد')} ${info['left']} ${t('days', 'أيام')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted;
    final good = contacts.where((c) => !['overdue', 'never'].contains(_dueInfo(c)['status'])).length;
    return Scaffold(
      appBar: AppBar(title: Text(t('Family and friends', 'الأهل والأصدقاء')), backgroundColor: Colors.transparent, elevation: 0),
      floatingActionButton: FloatingActionButton(onPressed: _addContact, child: const Icon(Icons.person_add)),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        if (contacts.isNotEmpty)
          Text('${t('In touch', 'على تواصل')}: $good / ${contacts.length}'),
        if (contacts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(t('Add the people you want to keep in touch with, and how often.', 'أضف الأشخاص الذين تريد التواصل معهم، وكل كم يوم.')),
          ),
        const SizedBox(height: 8),
        for (final c in sorted) _contactCard(context, c),
      ]),
    );
  }

  Widget _contactCard(BuildContext context, Map<String, dynamic> c) {
    final info = _dueInfo(c);
    final urgent = ['overdue', 'never', 'due'].contains(info['status']);
    final digits = (c['phone'] ?? '').toString().replaceAll(RegExp(r'[^\d]'), '').replaceFirst(RegExp(r'^00'), '');
    return Card(
      color: urgent ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text((c['name'] ?? '').toString(), style: Theme.of(context).textTheme.titleMedium)),
            Text(_statusText(info), style: Theme.of(context).textTheme.bodySmall),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: () {
                setState(() => contacts.remove(c));
                _save();
              },
            ),
          ]),
          Text('${t('Every', 'كل')} ${info['every']} ${t('days', 'أيام')}'),
          const SizedBox(height: 6),
          Wrap(spacing: 6, children: [
            ActionChip(label: Text('📞 ${t('Call', 'اتصال')}'), onPressed: () => _logContact(c, 'call')),
            ActionChip(label: Text('💬 ${t('Message', 'رسالة')}'), onPressed: () => _logContact(c, 'message')),
            ActionChip(label: Text('🚪 ${t('Visit', 'زيارة')}'), onPressed: () => _logContact(c, 'visit')),
            if (digits.isNotEmpty)
              ActionChip(
                label: const Text('WhatsApp'),
                onPressed: () => launchUrl(Uri.parse('https://wa.me/$digits'), mode: LaunchMode.externalApplication),
              ),
          ]),
        ]),
      ),
    );
  }

  Future<void> _addContact() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final every = TextEditingController(text: '7');
    final ok = await Get.dialog<bool>(AlertDialog(
      title: Text(t('Add a person', 'أضف شخصاً')),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: InputDecoration(labelText: t('Name', 'الاسم')), autofocus: true),
        TextField(controller: phone, decoration: InputDecoration(labelText: t('Phone', 'الهاتف')), keyboardType: TextInputType.phone),
        TextField(controller: every, decoration: InputDecoration(labelText: t('Contact every (days)', 'التواصل كل (أيام)')), keyboardType: TextInputType.number),
      ]),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: Text(t('Cancel', 'إلغاء'))),
        FilledButton(onPressed: () => Get.back(result: true), child: Text(t('Add', 'إضافة'))),
      ],
    ));
    if (ok == true && name.text.trim().isNotEmpty) {
      setState(() {
        contacts.add({
          'id': DateTime.now().microsecondsSinceEpoch.toString(),
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'every': int.tryParse(every.text.trim()) ?? 7,
          'last': null,
          'history': [],
        });
      });
      _save();
    }
  }
}
