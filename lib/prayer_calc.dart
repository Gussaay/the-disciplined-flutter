import 'package:adhan/adhan.dart';

/// Prayer times, ported from the React edition's prayer.js: computed
/// on the device with the adhan library (offline), the Qibla
/// direction, and the prayer-log scoring.
/// prayerLog[day] = { fajr: { s: 'ontime'|'late'|'missed', m: true } }

const List<List<String>> kPrayers = [
  ['fajr', 'Fajr', 'الفجر'],
  ['dhuhr', 'Dhuhr', 'الظهر'],
  ['asr', 'Asr', 'العصر'],
  ['maghrib', 'Maghrib', 'المغرب'],
  ['isha', 'Isha', 'العشاء'],
];

const List<List<String>> kPrayerMethods = [
  ['Egyptian', 'Egyptian General Authority', 'الهيئة المصرية العامة للمساحة'],
  ['UmmAlQura', 'Umm al-Qura (Makkah)', 'أم القرى (مكة)'],
  ['MuslimWorldLeague', 'Muslim World League', 'رابطة العالم الإسلامي'],
  ['Dubai', 'Dubai', 'دبي'],
  ['Qatar', 'Qatar', 'قطر'],
  ['Kuwait', 'Kuwait', 'الكويت'],
  ['Karachi', 'Karachi', 'كراتشي'],
  ['Turkey', 'Turkey (Diyanet)', 'تركيا (ديانت)'],
  ['NorthAmerica', 'North America (ISNA)', 'أمريكا الشمالية (إسنا)'],
  ['MoonsightingCommittee', 'Moonsighting Committee', 'لجنة رؤية الهلال'],
];

class PrayerPlace {
  const PrayerPlace(this.en, this.ar, this.lat, this.lng, this.method);
  final String en;
  final String ar;
  final double lat;
  final double lng;
  final String method;
}

const List<PrayerPlace> kCities = [
  PrayerPlace('Khartoum', 'الخرطوم', 15.5007, 32.5599, 'Egyptian'),
  PrayerPlace('Omdurman', 'أم درمان', 15.6445, 32.4777, 'Egyptian'),
  PrayerPlace('Port Sudan', 'بورتسودان', 19.6158, 37.2164, 'Egyptian'),
  PrayerPlace('Wad Madani', 'ود مدني', 14.4012, 33.5199, 'Egyptian'),
  PrayerPlace('Atbara', 'عطبرة', 17.7022, 33.9864, 'Egyptian'),
  PrayerPlace('Kassala', 'كسلا', 15.4510, 36.4000, 'Egyptian'),
  PrayerPlace('El Obeid', 'الأبيض', 13.1842, 30.2167, 'Egyptian'),
  PrayerPlace('Makkah', 'مكة المكرمة', 21.4225, 39.8262, 'UmmAlQura'),
  PrayerPlace('Madinah', 'المدينة المنورة', 24.4672, 39.6112, 'UmmAlQura'),
  PrayerPlace('Riyadh', 'الرياض', 24.7136, 46.6753, 'UmmAlQura'),
  PrayerPlace('Jeddah', 'جدة', 21.4858, 39.1925, 'UmmAlQura'),
  PrayerPlace('Dammam', 'الدمام', 26.4207, 50.0888, 'UmmAlQura'),
  PrayerPlace('Dubai', 'دبي', 25.2048, 55.2708, 'Dubai'),
  PrayerPlace('Abu Dhabi', 'أبوظبي', 24.4539, 54.3773, 'Dubai'),
  PrayerPlace('Sharjah', 'الشارقة', 25.3463, 55.4209, 'Dubai'),
  PrayerPlace('Doha', 'الدوحة', 25.2854, 51.5310, 'Qatar'),
  PrayerPlace('Kuwait City', 'مدينة الكويت', 29.3759, 47.9774, 'Kuwait'),
  PrayerPlace('Muscat', 'مسقط', 23.5880, 58.3829, 'UmmAlQura'),
  PrayerPlace('Manama', 'المنامة', 26.2285, 50.5860, 'UmmAlQura'),
  PrayerPlace('Cairo', 'القاهرة', 30.0444, 31.2357, 'Egyptian'),
  PrayerPlace('Alexandria', 'الإسكندرية', 31.2001, 29.9187, 'Egyptian'),
  PrayerPlace('Amman', 'عمّان', 31.9454, 35.9284, 'MuslimWorldLeague'),
  PrayerPlace('Baghdad', 'بغداد', 33.3152, 44.3661, 'MuslimWorldLeague'),
  PrayerPlace('Istanbul', 'إسطنبول', 41.0082, 28.9784, 'Turkey'),
  PrayerPlace('Juba', 'جوبا', 4.8594, 31.5713, 'Egyptian'),
  PrayerPlace('Addis Ababa', 'أديس أبابا', 9.0054, 38.7636, 'Egyptian'),
  PrayerPlace('Nairobi', 'نيروبي', -1.2921, 36.8219, 'Egyptian'),
  PrayerPlace('Kampala', 'كمبالا', 0.3476, 32.5825, 'Egyptian'),
  PrayerPlace('London', 'لندن', 51.5074, -0.1278, 'MoonsightingCommittee'),
  PrayerPlace('New York', 'نيويورك', 40.7128, -74.0060, 'NorthAmerica'),
];

CalculationParameters _params(Map<String, dynamic> settings) {
  final CalculationParameters p;
  switch ((settings['method'] ?? 'Egyptian').toString()) {
    case 'UmmAlQura':
      p = CalculationMethod.umm_al_qura.getParameters();
      break;
    case 'MuslimWorldLeague':
      p = CalculationMethod.muslim_world_league.getParameters();
      break;
    case 'Dubai':
      p = CalculationMethod.dubai.getParameters();
      break;
    case 'Qatar':
      p = CalculationMethod.qatar.getParameters();
      break;
    case 'Kuwait':
      p = CalculationMethod.kuwait.getParameters();
      break;
    case 'Karachi':
      p = CalculationMethod.karachi.getParameters();
      break;
    case 'Turkey':
      p = CalculationMethod.turkey.getParameters();
      break;
    case 'NorthAmerica':
      p = CalculationMethod.north_america.getParameters();
      break;
    case 'MoonsightingCommittee':
      p = CalculationMethod.moon_sighting_committee.getParameters();
      break;
    default:
      p = CalculationMethod.egyptian.getParameters();
  }
  p.madhab = settings['madhab'] == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
  return p;
}

/// The five prayer times (and sunrise) of a day.
Map<String, DateTime> prayerTimesFor(Map<String, dynamic> settings, [DateTime? date]) {
  final lat = (settings['lat'] as num?)?.toDouble() ?? kCities[0].lat;
  final lng = (settings['lng'] as num?)?.toDouble() ?? kCities[0].lng;
  final t = PrayerTimes(
    Coordinates(lat, lng),
    DateComponents.from(date ?? DateTime.now()),
    _params(settings),
  );
  return {
    'fajr': t.fajr,
    'sunrise': t.sunrise,
    'dhuhr': t.dhuhr,
    'asr': t.asr,
    'maghrib': t.maghrib,
    'isha': t.isha,
  };
}

double qiblaDirection(Map<String, dynamic> settings) {
  final lat = (settings['lat'] as num?)?.toDouble() ?? kCities[0].lat;
  final lng = (settings['lng'] as num?)?.toDouble() ?? kCities[0].lng;
  return Qibla(Coordinates(lat, lng)).direction;
}

/// Where the day stands: the current prayer and the next one.
Map<String, dynamic> prayerNow(Map<String, DateTime> times, DateTime now, [DateTime? tomorrowFajr]) {
  String? current;
  Map<String, dynamic>? next;
  for (final p in kPrayers) {
    final id = p[0];
    if (!times[id]!.isAfter(now)) {
      current = id;
    } else {
      next ??= {'id': id, 'at': times[id]};
    }
  }
  if (next == null && tomorrowFajr != null) next = {'id': 'fajr', 'at': tomorrowFajr};
  if (current == 'fajr' && !times['sunrise']!.isAfter(now)) current = null;
  return {
    'current': current,
    'next': next,
    'msLeft': next == null ? 0 : (next['at'] as DateTime).difference(now).inMilliseconds,
  };
}

const Map<String, double> _statusPoints = {'ontime': 1, 'late': 0.5, 'missed': 0};

Map<String, dynamic> daySummary(Map<String, dynamic> day) {
  var prayed = 0;
  var ontime = 0;
  var mosque = 0;
  var points = 0.0;
  for (final p in kPrayers) {
    final entry = day[p[0]];
    if (entry is! Map) continue;
    final s = entry['s']?.toString();
    if (s == 'ontime' || s == 'late') prayed += 1;
    if (s == 'ontime') ontime += 1;
    if (entry['m'] == true && s != 'missed') mosque += 1;
    points += _statusPoints[s] ?? 0;
  }
  return {'prayed': prayed, 'ontime': ontime, 'mosque': mosque, 'score': points / kPrayers.length};
}
