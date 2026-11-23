import 'dart:typed_data';

/// Reading OKOK / Chipsea body-fat scales from their Bluetooth
/// advertisements — a faithful port of the React edition's
/// scaleParse.js, which follows the scale maker's own app (OKOK by
/// Chipsea). `data` is the manufacturer data without its company id.
/// Chipsea checks no checksum on these frames, and neither does this.

const double _lb = 0.45359237;

int _be16(Uint8List d, int i) => (d[i] << 8) | d[i + 1];
int _le16(Uint8List d, int i) => (d[i + 1] << 8) | d[i];
double _round(double v, [int n = 2]) {
  final f = n == 2 ? 100 : 10;
  return (v * f).round() / f;
}

int _divider(int bits) => bits == 1 ? 1 : bits == 2 ? 100 : 10;

double _toKg(int raw, int attrib, int msb, int lsb) {
  final div = _divider((attrib >> 1) & 3);
  switch ((attrib >> 3) & 3) {
    case 1:
      return raw / div / 2; // jin
    case 2:
      return (raw / div) * _lb; // lb
    case 3:
      return (msb * 14 + lsb / div) * _lb; // st:lb
    default:
      return raw / div;
  }
}

double? _ohms(int raw) {
  if (raw == 0 || raw == 0xffff) return null;
  final v = raw > 1500 ? raw / 10 : raw.toDouble();
  return v >= 150 && v <= 1500 ? _round(v, 1) : null;
}

bool _plausible(double kg) => kg > 2 && kg < 300;

class ScaleReading {
  const ScaleReading({required this.format, this.weight, this.impedance, this.finalFlag, this.encrypted = false});
  final String format;
  final double? weight;
  final double? impedance;
  final bool? finalFlag;
  final bool encrypted;
}

/// One set of advertisements in, one reading out (or null). [mfr] maps
/// company id to the bytes without the company id, as flutter_blue_plus
/// hands them over.
ScaleReading? parseAdvert(Map<int, Uint8List> mfr) {
  for (final entry in mfr.entries) {
    final id = entry.key;
    final d = entry.value;
    if (id == 0x20ca && d.length >= 13) {
      // Properties bit0 set: a status frame, not a measurement.
      if (d[6] & 1 != 0) continue;
      final weight = _toKg(_be16(d, 8), d[6], d[8], d[9]);
      if (!_plausible(weight)) continue;
      return ScaleReading(format: 'V20', weight: _round(weight), impedance: _ohms(_be16(d, 10)));
    }
    if (id == 0x11ca && d.length >= 7) {
      if (d.length < 10) continue;
      final weight = _toKg(_be16(d, 3), d[9], d[3], d[4]);
      if (!_plausible(weight)) continue;
      return ScaleReading(format: 'V11', weight: _round(weight));
    }
    if ((id & 0xff) == 0xc0 && d.length >= 13) {
      // Encrypted V2 scale: bit7 of the impedance high byte.
      if (d[2] & 0x80 != 0) {
        return const ScaleReading(format: 'V2', encrypted: true);
      }
      final weight = _toKg(_be16(d, 0), d[6], d[0], d[1]);
      if (!_plausible(weight)) continue;
      return ScaleReading(format: 'C0', weight: _round(weight), impedance: _ohms(_be16(d, 2)), finalFlag: (d[6] & 1) == 1);
    }
    if (id == 0xf0ff && d.length >= 4) {
      final weight = _le16(d, 2) / 10;
      if (!_plausible(weight)) continue;
      return ScaleReading(format: 'VF0', weight: _round(weight));
    }
  }
  return null;
}

/// Follows the readings while someone stands on the scale and says
/// when the measurement is done: at once when the scale flags it
/// final, otherwise once the same weight has held for [holdMs].
class ScaleSettler {
  ScaleSettler({this.holdMs = 2500});
  final int holdMs;
  double? _last;
  int _since = 0;
  bool _done = false;

  /// Returns true when the reading has settled.
  bool push(ScaleReading? reading, int nowMs) {
    if (reading == null || reading.weight == null || _done) return false;
    if (reading.finalFlag == true && reading.weight! > 2) {
      _done = true;
      return true;
    }
    if (reading.finalFlag == false) {
      _last = reading.weight;
      _since = nowMs;
      return false;
    }
    if (_last == null || (reading.weight! - _last!).abs() > 0.05) {
      _last = reading.weight;
      _since = nowMs;
      return false;
    }
    if (nowMs - _since >= holdMs) {
      _done = true;
      return true;
    }
    return false;
  }

  void reset() {
    _last = null;
    _since = 0;
    _done = false;
  }
}
