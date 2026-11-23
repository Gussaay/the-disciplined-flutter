import 'package:flutter_test/flutter_test.dart';
import 'package:the_disciplined/data/lessons.dart';

void main() {
  test('two B2 lessons: shadowing and communication', () {
    expect(kLessons.length, 2);
    expect(kLessons.map((l) => l.skill), containsAll(['shadowing', 'communication']));
    for (final l in kLessons) {
      expect(l.level, 'B2');
      expect(l.title.en, isNotEmpty);
      expect(l.title.ar, isNotEmpty);
      expect(l.intro.en.length, greaterThan(100));
      expect(l.intro.ar, isNotEmpty);
      expect(l.steps.length, greaterThanOrEqualTo(4));
      expect(l.phrases, isNotEmpty);
      expect(l.exercises.length, 3);
      for (final e in l.exercises) {
        expect(e.instructions.en, isNotEmpty);
        expect(e.instructions.ar, isNotEmpty);
      }
    }
  });

  test('exercise ids are unique (they are written into the english log)', () {
    final ids = [for (final l in kLessons) for (final e in l.exercises) e.id];
    expect(ids.toSet().length, ids.length);
    expect(ids.length, 6);
  });

  test('shadowing scripts: news has 8+ lines, dialogue has 8+ turns', () {
    final shadowing = kLessons.firstWhere((l) => l.skill == 'shadowing');
    final lineCounts = [for (final e in shadowing.exercises) e.lines.length];
    expect(lineCounts.any((n) => n >= 9), isTrue, reason: 'news script');
    expect(lineCounts.any((n) => n >= 10), isTrue, reason: 'dialogue');
  });
}
