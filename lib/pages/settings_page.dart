import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../update_check.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/app_controller.dart';
import '../data/food_controller.dart';

/// Settings (milestone 2): the profile that drives the daily targets,
/// the calorie target override, your own AI keys (kept on the device),
/// and the theme. The app lock joins with the Firebase milestone.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _box = GetStorage();
  late final TextEditingController _name;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _age;
  late final TextEditingController _kcal;
  late final TextEditingController _gemini;
  late final TextEditingController _groq;
  String _sex = 'male';
  String _activity = 'light';
  String _goal = 'gain';
  String _theme = 'system';

  @override
  void initState() {
    super.initState();
    final c = Get.find<FoodController>();
    final p = c.profile;
    _name = TextEditingController(text: (p['name'] ?? '').toString());
    _weight = TextEditingController(text: (p['weight'] ?? '').toString());
    _height = TextEditingController(text: (p['height'] ?? '').toString());
    _age = TextEditingController(text: (p['age'] ?? '').toString());
    final targets = p['targets'];
    _kcal = TextEditingController(text: targets is Map && targets['kcal'] != null ? targets['kcal'].toString() : '2800');
    final keys = _box.read<Map>('aiKeys') ?? {};
    _gemini = TextEditingController(text: (keys['gemini'] ?? '').toString());
    _groq = TextEditingController(text: (keys['groq'] ?? '').toString());
    _sex = (p['sex'] ?? 'male').toString();
    _activity = (p['activity'] ?? 'light').toString();
    _goal = (p['goal'] ?? 'gain').toString();
    _theme = (_box.read<String>('themeMode') ?? 'system');
  }

  @override
  void dispose() {
    for (final t in [_name, _weight, _height, _age, _kcal, _gemini, _groq]) {
      t.dispose();
    }
    super.dispose();
  }

  void _save() {
    final c = Get.find<FoodController>();
    final next = Map<String, dynamic>.from(c.profile);
    next['name'] = _name.text.trim();
    final w = double.tryParse(_weight.text);
    if (w != null) next['weight'] = w;
    final h = double.tryParse(_height.text);
    if (h != null) next['height'] = h;
    final a = int.tryParse(_age.text);
    if (a != null) next['age'] = a;
    next['sex'] = _sex;
    next['activity'] = _activity;
    next['goal'] = _goal;
    final kcal = int.tryParse(_kcal.text);
    final targets = Map<String, dynamic>.from(next['targets'] is Map ? next['targets'] as Map : {});
    if (kcal != null) targets['kcal'] = kcal;
    next['targets'] = targets;
    c.saveProfile(next);
    _box.write('aiKeys', {'gemini': _gemini.text.trim(), 'groq': _groq.text.trim()});
    _box.write('themeMode', _theme);
    Get.changeThemeMode(_theme == 'dark' ? ThemeMode.dark : _theme == 'light' ? ThemeMode.light : ThemeMode.system);
    Get.snackbar(L('Saved', 'تم الحفظ'), L('Your settings are saved on this device.', 'حُفظت إعداداتك على هذا الجهاز.'),
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
  }

  Widget _field(TextEditingController c, String label, {bool number = false, bool secret = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        obscureText: secret,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _chips(String title, List<List<String>> options, String value, void Function(String) onPick) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              for (final o in options)
                ChoiceChip(label: Text(o[1]), selected: value == o[0], onSelected: (_) => setState(() => onPick(o[0]))),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L('Settings', 'الإعدادات'), style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: Get.back),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(L('Profile', 'الملف الشخصي'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _field(_name, L('Name', 'الاسم')),
                  _field(_weight, L('Weight (kg)', 'الوزن (كجم)'), number: true),
                  _field(_height, L('Height (cm)', 'الطول (سم)'), number: true),
                  _field(_age, L('Age', 'العمر'), number: true),
                  _chips(L('Sex', 'الجنس'), [
                    ['male', L('Male', 'ذكر')],
                    ['female', L('Female', 'أنثى')],
                  ], _sex, (v) => _sex = v),
                  _chips(L('Activity', 'النشاط'), [
                    ['sedentary', L('Sedentary', 'قليل الحركة')],
                    ['light', L('Light', 'خفيف')],
                    ['moderate', L('Moderate', 'متوسط')],
                    ['active', L('Active', 'عالٍ')],
                  ], _activity, (v) => _activity = v),
                  _chips(L('Goal', 'الهدف'), [
                    ['lose', L('Lose weight', 'إنقاص الوزن')],
                    ['maintain', L('Maintain', 'المحافظة')],
                    ['gain', L('Gain muscle', 'زيادة العضلات')],
                  ], _goal, (v) => _goal = v),
                  _field(_kcal, L('Daily calorie target (kcal)', 'هدف السعرات اليومي'), number: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(L('AI coach keys', 'مفاتيح المدرب الذكي'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    L('Your own keys, kept only on this device, the same as the React app.', 'مفاتيحك الخاصة، محفوظة على هذا الجهاز فقط، كما في تطبيق React.'),
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  _field(_gemini, 'Gemini API key', secret: true),
                  _field(_groq, 'Groq API key', secret: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(L('Appearance', 'المظهر'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 8),
                  _chips(L('Theme', 'السمة'), [
                    ['system', L('System', 'النظام')],
                    ['light', L('Light', 'فاتح')],
                    ['dark', L('Dark', 'داكن')],
                  ], _theme, (v) => _theme = v),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: Text(L('Save', 'حفظ'))),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L('App updates', 'تحديثات التطبيق'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    L('Version $kAppVersion (build $kAppBuild). Updates are free: the app checks the GitHub Release and offers the new APK directly.', 'الإصدار $kAppVersion (بناء $kAppBuild). التحديثات مجانية: يتحقق التطبيق من إصدار GitHub ويعرض ملف APK الجديد مباشرة.'),
                  ),
                  const SizedBox(height: 8),
                  _UpdateButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text('The Disciplined (Flutter) · v$kAppVersion', style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }
}

class _UpdateButton extends StatefulWidget {
  @override
  State<_UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<_UpdateButton> {
  bool busy = false;
  String result = '';
  UpdateInfo? update;

  Future<void> _check() async {
    setState(() {
      busy = true;
      result = '';
    });
    final info = await checkForUpdate();
    setState(() {
      busy = false;
      update = info != null && info.isNewer ? info : null;
      result = info == null
          ? 'Could not check now.'
          : info.isNewer
              ? 'Version ${info.version} is available.'
              : 'You have the latest version.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          FilledButton.tonal(
            onPressed: busy ? null : _check,
            child: Text(busy ? 'Checking…' : 'Check for updates'),
          ),
          if (update != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FilledButton(
                onPressed: () => launchUrl(Uri.parse(update!.apk), mode: LaunchMode.externalApplication),
                child: const Text('Download the new APK'),
              ),
            ),
        ]),
        if (result.isNotEmpty)
          Padding(padding: const EdgeInsets.only(top: 6), child: Text(result)),
      ],
    );
  }
}
