import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_disciplined/body_comp.dart';
import 'package:the_disciplined/data/gym_data.dart';
import 'package:the_disciplined/data/gym_photos.dart';
import 'package:the_disciplined/data/surahs.dart';
import 'package:the_disciplined/data/words.dart';
import 'package:the_disciplined/gym_logic.dart';
import 'package:the_disciplined/ls02.dart';
import 'package:the_disciplined/prayer_calc.dart';
import 'package:the_disciplined/scale_parse.dart';
import 'package:the_disciplined/update_check.dart';

void main() {
  group('gym catalogue (milestone 3)', () {
    test('27 tools and 65 exercises, like the React edition', () {
      expect(kTools.length, 27);
      var exercises = 0;
      for (final tool in kTools) {
        exercises += tool.exercises.length;
        expect(kToolPhotos[tool.id], isNotNull, reason: 'photo for ${tool.id}');
      }
      expect(exercises, 65);
    });

    test('targets and setup data resolve', () {
      expect(kTargets['bench_press']!.primary, contains('chest'));
      expect(kToolSetup['lat_pulldown'], isNotEmpty);
      expect(kPrograms.length, 4);
    });

    test('toolStats counts a finished session', () {
      final sessions = <Map<String, dynamic>>[
        {
          'id': '1',
          'date': '2026-11-23',
          'startedAt': 1000,
          'endedAt': 2000,
          'name': 'Test',
          'exercises': [
            {
              'exerciseId': 'bench_press',
              'unit': 'kg',
              'sets': [
                {'weight': 60, 'reps': 10, 'done': true},
                {'weight': 60, 'reps': 8, 'done': true},
                {'weight': 60, 'reps': 8, 'done': false},
              ],
            },
          ],
        },
      ];
      final tool = kTools.firstWhere((t) => t.id == 'bench');
      final stats = toolStats(sessions, tool.exercises.map((e) => e.id).toSet());
      expect(stats.sessions, 1);
      expect(stats.sets, 2);
      expect(stats.volume, 60 * 18);
      expect(oneRepMax(60, 10), 80);
    });
  });

  group('scale parsing (Chipsea)', () {
    test("Easy's real Yoda1 frame reads 57.5 kg, 500 ohm, final", () {
      final mfr = <int, Uint8List>{
        0x03c0: Uint8List.fromList([0x16, 0x76, 0x13, 0x88, 0x00, 0x00, 0x25, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
      };
      final r = parseAdvert(mfr);
      expect(r, isNotNull);
      expect(r!.format, 'C0');
      expect(r.weight, 57.5);
      expect(r.impedance, 500);
      expect(r.finalFlag, true);
      final settler = ScaleSettler();
      expect(settler.push(r, 1000), true);
    });

    test('V20 status frames carry no weight', () {
      final mfr = <int, Uint8List>{
        0x20ca: Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0, 0x16, 0x76, 0x01, 0xf4, 0]),
      };
      expect(parseAdvert(mfr), isNull);
    });

    test('body composition stays in range', () {
      final c = bodyComposition(weight: 57.5, impedance: 500, height: 170, age: 30);
      expect(c['bmi'], closeTo(19.9, 0.2));
      expect(c['fat'] as double, inInclusiveRange(5, 75));
      expect(c['muscle'] as double, greaterThan(10));
    });
  });

  group('watch protocol (GloryFit / LS02)', () {
    test('command bytes match GloryFit', () {
      expect(Ls02Cmd.heartStart(), [0xe5, 0x11]);
      expect(Ls02Cmd.bpStart(), [0xc7, 0x11]);
      expect(Ls02Cmd.spo2Start(), [0x34, 0x11]);
      expect(Ls02Cmd.findBand(), [0xab, 0, 0, 0, 1, 3, 7, 1]);
      expect(Ls02Cmd.powerOff(), [0xe8, 0x11]);
    });

    test('replies parse', () {
      expect(parseLs02([0xa2, 79]), {'type': 'battery', 'level': 79});
      expect(parseLs02([0xe5, 0x11, 0, 72])?['bpm'], 72);
      final bp = parseLs02([0xc7, 0x11, 0, 120, 80]);
      expect(bp?['systolic'], 120);
      expect(bp?['diastolic'], 80);
      expect(parseLs02([0x34, 0x11, 0, 98])?['spo2'], 98);
    });
  });

  group('prayer and the rest (milestone 4)', () {
    test('Khartoum times are sane and ordered', () {
      final times = prayerTimesFor({}, DateTime(2026, 11, 23));
      expect(times['fajr']!.hour, inInclusiveRange(4, 5));
      expect(times['maghrib']!.hour, inInclusiveRange(17, 18));
      final order = ['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];
      for (var i = 1; i < order.length; i++) {
        expect(times[order[i]]!.isAfter(times[order[i - 1]]!), true, reason: order[i]);
      }
    });

    test('day summary scores a full on-time day as 1', () {
      final day = {for (final p in kPrayers) p[0]: {'s': 'ontime', 'm': true}};
      final s = daySummary(day);
      expect(s['score'], 1.0);
      expect(s['mosque'], 5);
    });

    test('surahs and words data are complete', () {
      expect(kSurahs.length, 114);
      expect(kSurahs.first.ayahs, 7);
      expect(kWordLevels['A1']!.length, 30);
    });

    test('this build is 1.2.0 build 3', () {
      expect(kAppVersion, '1.2.0');
      expect(kAppBuild, 3);
    });
  });
}
