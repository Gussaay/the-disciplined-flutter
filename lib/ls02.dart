// Watches on Realtek chips (the GZCSW02 among them) — a port of the
// React edition's ls02.js: the GloryFit command set on the general
// channel (55FF/33F1) and the notification parser. Pure functions.

String _base(String short) => '0000$short-0000-1000-8000-00805f9b34fb';

class Ls02Uuids {
  static final general = _base('55ff');
  static final generalWrite = _base('33f1');
  static final generalNotify = _base('33f2');
  static final data = _base('60ff');
  static final dataWrite = _base('6001');
  static final dataNotify = _base('6002');
}

int _u16(List<int> p, int i) => (p[i] << 8) | p[i + 1];

class Ls02Cmd {
  static List<int> battery() => [0xa2];
  static List<int> time([DateTime? d]) {
    final t = d ?? DateTime.now();
    return [0x04, (t.year >> 8) & 0xff, t.year & 0xff, t.month, t.day, t.hour, t.minute, t.second];
  }

  static List<int> steps() => [0xb2, 0x03, 0x01];
  static List<int> heartStart() => [0xe5, 0x11];
  static List<int> heartStop() => [0xe5, 0x00];
  static List<int> bpStart() => [0xc7, 0x11];
  static List<int> bpStop() => [0xc7, 0x00];
  static List<int> spo2Start() => [0x34, 0x11];
  static List<int> spo2Stop() => [0x34, 0x00];
  static List<int> heartAutoOn() => [0xf7, 0x01];
  static List<int> heartAutoOff() => [0xf7, 0x02];
  static List<int> findBand([int repeats = 3]) => [0xab, 0, 0, 0, 1, repeats & 0xff, 7, 1];
  static List<int> shakePhotoOn() => [0xc4, 0x01];
  static List<int> shakePhotoOff() => [0xc4, 0x03];
  static List<int> powerOff() => [0xe8, 0x11];
  static List<int> firmware() => [0xa1];
  static List<int> format() => [0x01, 0x01, 0x01];

  static List<int> alarm({bool on = true, int hour = 7, int minute = 0, int cycle = 62, int shake = 0}) => on
      ? [0xab, cycle & 0xff, hour & 0xff, minute & 0xff, 2, shake & 0xff, 2, 0, 0]
      : [0xab, cycle & 0xff, hour & 0xff, minute & 0xff, 0, 0, 0, 0, 0];

  static List<int> drinkReminder({
    bool on = true,
    int minutes = 60,
    int fromHour = 8,
    int fromMinute = 0,
    int toHour = 22,
    int toMinute = 0,
    bool lunchBreak = false,
  }) => [
        0xdc, on ? 1 : 0, minutes & 0xff, 2, 3, 1, 0,
        fromHour & 0xff, fromMinute & 0xff, toHour & 0xff, toMinute & 0xff, lunchBreak ? 1 : 0,
      ];

  static List<int> user({
    String sex = 'male',
    int age = 30,
    int height = 170,
    int weight = 70,
    int stepGoal = 8000,
    int screen = 10,
    bool wrist = true,
  }) {
    final goal = stepGoal < 1000 ? 1000 : (stepGoal > 60000 ? 60000 : stepGoal);
    return [
      0x05, 0x00, height & 0xff, 0x00, weight & 0xff, screen < 3 ? 3 : (screen > 30 ? 30 : screen), 0x00, 0x00,
      (goal >> 8) & 0xff, goal & 0xff, wrist ? 0x01 : 0x00, 0xa0, 0x00, age & 0xff, sex == 'female' ? 0x02 : 0x01, 0x00, 0x01, 0x01, 0x28,
    ];
  }
}

bool _sameDay(List<int> p, int i, DateTime now) =>
    _u16(p, i) == now.year && p[i + 2] == now.month && p[i + 3] == now.day;

int? _bpmOf(int v) => (v > 25 && v < 230) ? v : null;

// Reads one notification. [steps] is the caller's hour → steps map for
// today; a step history ends with {type: 'day', steps: total}.
Map<String, dynamic>? parseLs02(List<int> p, {DateTime? now, Map<int, int>? steps}) {
  final t = now ?? DateTime.now();
  final stepMap = steps ?? <int, int>{};
  if (p.isEmpty) return null;
  final id = p[0];
  if (id == 0xa2 && p.length >= 2) return {'type': 'battery', 'level': p[1]};
  if (id == 0xa1 && p.length > 1) {
    return {'type': 'firmware', 'text': String.fromCharCodes(p.sublist(1).where((b) => b >= 0x20 && b < 0x7f))};
  }
  if ((id == 0xe5 || id == 0x16) && p.length >= 2 && (p[1] == 0x11 || p[1] == 0x00) && p.length >= 4) {
    final bpm = _bpmOf(p[3]);
    return bpm != null ? {'type': 'heart', 'bpm': bpm, 'live': p[1] == 0x11} : null;
  }
  if ((id == 0xe5 || id == 0x16) && p.length <= 3 && p.length >= 2) {
    return {'type': 'heartScreen', 'open': p[1] == 0x11};
  }
  if ((id == 0x18 || id == 0xf7) && p.length >= 9 && p[1] == 0x03) {
    final bpm = _bpmOf(p[8]);
    if (bpm == null || !_sameDay(p, 2, t)) return {'type': 'old'};
    return {'type': 'heart', 'bpm': bpm, 'auto': true, 'minute': p[6] * 60 + p[7]};
  }
  if ((id == 0x18 || id == 0xf7) && p.length >= 11 && p[1] == 0x04) {
    final bpm = _bpmOf(p[10]);
    if (bpm == null || !_sameDay(p, 2, t)) return {'type': 'old'};
    return {'type': 'heart', 'bpm': bpm, 'bpmMax': _bpmOf(p[8]), 'bpmMin': _bpmOf(p[9]), 'minute': p[6] * 60 + p[7]};
  }
  if (id == 0x18 && p.length >= 18 && p[1] == 0x07) {
    if (!_sameDay(p, 1, t)) return {'type': 'old'};
    final points = <List<int>>[];
    for (var i = 0; i < 12; i++) {
      final bpm = _bpmOf(p[6 + i]);
      if (bpm != null) points.add([p[5] * 60 + i * 10, bpm]);
    }
    return {'type': 'heartHistory', 'points': points};
  }
  if (id == 0x18 && p.length >= 2 && (p[1] == 0x01 || p[1] == 0x02 || p[1] == 0xfd)) {
    return {'type': 'ack', 'what': 'heart'};
  }
  if (id == 0xc7 && p.length >= 5) {
    final systolic = p[3];
    final diastolic = p[4];
    if (systolic > 50 && systolic < 260 && diastolic > 25 && diastolic < 200 && systolic > diastolic) {
      return {'type': 'bp', 'systolic': systolic, 'diastolic': diastolic};
    }
    return null;
  }
  if (id == 0x34 && p.length >= 4) {
    final spo2 = p[3];
    return (spo2 >= 60 && spo2 <= 100) ? {'type': 'spo2', 'spo2': spo2} : null;
  }
  if ((id == 0xb2 || id == 0x0a) && p.length >= 2 && p[1] == 0xfd) {
    return {'type': 'day', 'steps': stepMap.values.fold(0, (a, b) => a + b)};
  }
  if ((id == 0xb2 || id == 0x0a) && p.length >= 8 && p[1] == 0x07) {
    if (_sameDay(p, 1, t)) stepMap[p[5]] = _u16(p, 6);
    return {'type': 'stepsRow'};
  }
  if ((id == 0x09 || id == 0xb1) && p.length >= 8) return {'type': 'stepsChanged'};
  if ((id == 0xd1 || id == 0x12) && p.length >= 2 && p[1] == 0x0a) return {'type': 'findPhone'};
  if (id == 0xfd && p.length >= 3 && (p[1] == 0x11 || p[1] == 0x00)) {
    return {'type': 'sport', 'on': p[1] == 0x11, 'kind': p[2]};
  }
  if (id == 0xbe && p.length >= 3 && p[1] == 0x02) return {'type': 'silent', 'on': p[2] == 0x00};
  if (id == 0x04 && p.length >= 8) return {'type': 'ack', 'what': 'time'};
  if (id == 0x01 && p.length >= 3) return {'type': 'ack', 'what': 'format'};
  if (id == 0x0f) return {'type': 'ack', 'what': 'alert'};
  if (id == 0x11) return {'type': 'ack', 'what': 'weather'};
  if (id == 0x1c || id == 0x33) return {'type': 'ack', 'what': 'pair'};
  return null;
}
