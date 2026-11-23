import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../data/app_controller.dart';
import '../data/surahs.dart';

/// The Quran (milestone 4): the surah list, and a reader that loads
/// each surah's text from the same public files the React edition
/// uses, cached on the device after the first read. Reading progress
/// and the bookmark live in 'quranProgress' / 'quranBookmark'.
class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    String t(String en, String ar) => L(en, ar);
    final box = GetStorage();
    final progress = Map<String, dynamic>.from(box.read<Map>('quranProgress') ?? {});
    final readCount = progress.values.where((v) => v == true).length;
    return Scaffold(
      appBar: AppBar(title: Text(t('Quran', 'القرآن')), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        Text('${t('Surahs read', 'سور مقروءة')}: $readCount / 114'),
        const SizedBox(height: 8),
        for (final s in kSurahs)
          ListTile(
            leading: CircleAvatar(child: Text('${s.id}', style: const TextStyle(fontSize: 11))),
            title: Text(s.name, style: const TextStyle(fontSize: 17)),
            subtitle: Text('${s.tr} · ${s.en} · ${s.ayahs} ${t('verses', 'آيات')} · ${s.type}'),
            trailing: progress['${s.id}'] == true ? const Icon(Icons.check_circle, color: Colors.green) : null,
            onTap: () => Get.to(() => SurahReaderPage(surah: s)),
          ),
      ]),
    );
  }
}

class SurahReaderPage extends StatefulWidget {
  const SurahReaderPage({super.key, required this.surah});

  final SurahInfo surah;

  @override
  State<SurahReaderPage> createState() => _SurahReaderPageState();
}

class _SurahReaderPageState extends State<SurahReaderPage> {
  final box = GetStorage();
  List<List<String>>? verses;
  String? error;
  bool showEnglish = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cacheKey = 'quranText${widget.surah.id}';
    final cached = box.read<String>(cacheKey);
    if (cached != null) {
      _setVerses(cached);
      return;
    }
    try {
      final res = await http.get(Uri.parse('https://disciplined-3e309.web.app/quran/${widget.surah.id}.json'));
      if (res.statusCode == 200) {
        await box.write(cacheKey, res.body);
        _setVerses(res.body);
      } else {
        setState(() => error = 'HTTP ${res.statusCode}');
      }
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  void _setVerses(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    setState(() {
      verses = ((data['v'] as List) ?? []).map((v) => (v as List).map((x) => x.toString()).toList()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    String t(String en, String ar) => L(en, ar);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(showEnglish ? Icons.translate : Icons.translate_outlined),
            onPressed: () => setState(() => showEnglish = !showEnglish),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: t('Bookmark here', 'ضع علامة هنا'),
            onPressed: () {
              box.write('quranBookmark', {'surah': widget.surah.id, 'at': DateTime.now().millisecondsSinceEpoch});
              Get.snackbar(t('Bookmarked', 'حُفظت العلامة'), widget.surah.name, snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: verses == null
          ? Center(child: error != null ? Text('${t('Could not load this surah', 'تعذر تحميل هذه السورة')}: $error') : const CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
              for (var i = 0; i < verses!.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(
                      '${verses![i][0]} ﴿${i + 1}﴾',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 21, height: 1.9),
                    ),
                    if (showEnglish && verses![i].length > 1)
                      Text(verses![i][1], style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  final progress = Map<String, dynamic>.from(box.read<Map>('quranProgress') ?? {});
                  progress['${widget.surah.id}'] = true;
                  box.write('quranProgress', progress);
                  Get.back();
                },
                icon: const Icon(Icons.check),
                label: Text(t('Mark as read', 'تمّت القراءة')),
              ),
            ]),
    );
  }
}
