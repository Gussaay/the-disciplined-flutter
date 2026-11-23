import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/app_controller.dart';
import '../data/food_controller.dart';
import '../prayer_calc.dart';

/// Prayer (milestone 4): times computed on the device, the Qibla
/// direction, and the daily log — on time, late, missed, in the
/// mosque — with the week summary. Stores: 'prayerSettings',
/// 'prayerLog', the React edition's shapes.
class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key});

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  final box = GetStorage();
  final app = Get.find<AppController>();
  late Map<String, dynamic> settings;
  late Map<String, dynamic> log;

  String t(String en, String ar) => L(en, ar);

  @override
  void initState() {
    super.initState();
    settings = Map<String, dynamic>.from(box.read<Map>('prayerSettings') ?? {
      'lat': kCities[0].lat,
      'lng': kCities[0].lng,
      'method': kCities[0].method,
      'name': kCities[0].en,
      'madhab': 'shafi',
    });
    log = Map<String, dynamic>.from(box.read<Map>('prayerLog') ?? {});
  }

  String get today => FoodController.dayKey(DateTime.now());

  Map<String, dynamic> get todayLog => Map<String, dynamic>.from(log[today] is Map ? log[today] as Map : {});

  void _setPrayer(String id, String? status, {bool? mosque}) {
    setState(() {
      final day = todayLog;
      final entry = Map<String, dynamic>.from(day[id] is Map ? day[id] as Map : {});
      if (status != null) entry['s'] = status;
      if (mosque != null) entry['m'] = mosque;
      day[id] = entry;
      log[today] = day;
    });
    box.write('prayerLog', log);
  }

  String _fmt(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ap = d.hour < 12 ? 'AM' : 'PM';
    return '$h:${d.minute.toString().padLeft(2, '0')} $ap';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final times = prayerTimesFor(settings, now);
    final tomorrow = prayerTimesFor(settings, now.add(const Duration(days: 1)));
    final nowInfo = prayerNow(times, now, tomorrow['fajr']);
    final summary = daySummary(todayLog);
    final nextId = (nowInfo['next'] as Map?)?['id']?.toString();
    return Scaffold(
      appBar: AppBar(title: Text(t('Prayer', 'الصلاة')), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 6),
                Expanded(child: Text((settings['name'] ?? 'Khartoum').toString(), style: Theme.of(context).textTheme.titleMedium)),
                TextButton(
                  onPressed: () async {
                    final picked = await Get.dialog<PrayerPlace>(AlertDialog(
                      title: Text(t('Choose your city', 'اختر مدينتك')),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(shrinkWrap: true, children: [
                          for (final c in kCities)
                            ListTile(title: Text(L(c.en, c.ar)), onTap: () => Get.back(result: c)),
                        ]),
                      ),
                    ));
                    if (picked != null) {
                      setState(() {
                        settings = {...settings, 'lat': picked.lat, 'lng': picked.lng, 'method': picked.method, 'name': picked.en};
                      });
                      box.write('prayerSettings', settings);
                    }
                  },
                  child: Text(t('Change', 'تغيير')),
                ),
              ]),
              const SizedBox(height: 4),
              if (nextId != null)
                Text(
                  '${t('Next', 'التالية')}: ${L(kPrayers.firstWhere((p) => p[0] == nextId)[1], kPrayers.firstWhere((p) => p[0] == nextId)[2])} · ${_fmt((nowInfo['next'] as Map)['at'] as DateTime)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              Text('${t('Qibla', 'القبلة')}: ${qiblaDirection(settings).toStringAsFixed(0)}°'),
              Text('${t('Prayed today', 'صليت اليوم')}: ${summary['prayed']}/5 · ${t('on time', 'في الوقت')}: ${summary['ontime']} · ${t('mosque', 'مسجد')}: ${summary['mosque']}'),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        for (final p in kPrayers) _prayerRow(context, p, times[p[0]]!, nextId == p[0]),
        ListTile(
          leading: const Icon(Icons.wb_sunny_outlined),
          title: Text(t('Sunrise', 'الشروق')),
          trailing: Text(_fmt(times['sunrise']!)),
        ),
        const SizedBox(height: 12),
        Text(t('This week', 'هذا الأسبوع'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        _weekBars(context),
      ]),
    );
  }

  Widget _prayerRow(BuildContext context, List<String> p, DateTime at, bool isNext) {
    final entry = todayLog[p[0]];
    final status = entry is Map ? entry['s']?.toString() : null;
    final mosque = entry is Map && entry['m'] == true;
    return Card(
      color: isNext ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(L(p[1], p[2]), style: Theme.of(context).textTheme.titleMedium)),
            Text(_fmt(at)),
          ]),
          const SizedBox(height: 6),
          Wrap(spacing: 6, children: [
            for (final s in [
              ['ontime', 'On time', 'في الوقت'],
              ['late', 'Late', 'متأخر'],
              ['missed', 'Missed', 'فاتتني'],
            ])
              ChoiceChip(
                label: Text(L(s[1], s[2])),
                selected: status == s[0],
                onSelected: (on) {
                  if (on) _setPrayer(p[0], s[0]);
                },
              ),
            FilterChip(
              label: Text('🕌 ${t('Mosque', 'مسجد')}'),
              selected: mosque,
              onSelected: (on) => _setPrayer(p[0], null, mosque: on),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _weekBars(BuildContext context) {
    final rows = <Map<String, dynamic>>[];
    for (var i = 6; i >= 0; i--) {
      final d = DateTime.now().subtract(Duration(days: i));
      final key = FoodController.dayKey(d);
      final day = log[key] is Map ? Map<String, dynamic>.from(log[key] as Map) : <String, dynamic>{};
      rows.add({'key': key, ...daySummary(day)});
    }
    final total = rows.fold<int>(0, (s, r) => s + (r['prayed'] as int));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$total / 35 ${t('prayers this week', 'صلاة هذا الأسبوع')}'),
      const SizedBox(height: 8),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        for (final r in rows)
          Expanded(
            child: Column(children: [
              Container(
                height: 8 + (r['score'] as double) * 52,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Text((r['key'] as String).substring(8), style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
      ]),
    ]);
  }
}
