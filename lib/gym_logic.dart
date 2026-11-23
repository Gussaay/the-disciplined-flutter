// Training maths, ported from the React edition's gym.js and
// gymSession.js. A session is a map:
// { id, date: 'YYYY-MM-DD', startedAt, endedAt, name,
//   exercises: [{ exerciseId, unit, muscle, sets: [{ reps, weight,
//   seconds, minutes, km, done }] }] }

double _n(Object? v) => v is num ? v.toDouble() : 0;

double oneRepMax(double weight, double reps) {
  if (weight == 0 || reps == 0) return 0;
  return reps == 1 ? weight : (weight * (1 + reps / 30) * 10).round() / 10;
}

List<Map<String, dynamic>> doneSets(Map<String, dynamic> exercise) =>
    ((exercise['sets'] as List?) ?? []).whereType<Map>().map((s) => Map<String, dynamic>.from(s)).where((s) => s['done'] == true).toList();

double sessionVolume(Map<String, dynamic> session) {
  var sum = 0.0;
  for (final e in ((session['exercises'] as List?) ?? []).whereType<Map>()) {
    for (final s in doneSets(Map<String, dynamic>.from(e))) {
      sum += _n(s['weight']) * _n(s['reps']);
    }
  }
  return sum;
}

int sessionSets(Map<String, dynamic> session) {
  var sum = 0;
  for (final e in ((session['exercises'] as List?) ?? []).whereType<Map>()) {
    sum += doneSets(Map<String, dynamic>.from(e)).length;
  }
  return sum;
}

int sessionMinutes(Map<String, dynamic> session) {
  final a = session['startedAt'];
  final b = session['endedAt'];
  if (a is! num || b is! num) return 0;
  final m = ((b - a) / 60000).round();
  return m < 1 ? 1 : m;
}

// The last finished performance of an exercise: its done sets + date.
Map<String, dynamic>? lastPerformance(List<Map<String, dynamic>> sessions, String exerciseId) {
  Map<String, dynamic>? found;
  for (final s in sessions) {
    if (s['endedAt'] == null) continue;
    for (final e in ((s['exercises'] as List?) ?? []).whereType<Map>()) {
      if (e['exerciseId'] != exerciseId) continue;
      final done = doneSets(Map<String, dynamic>.from(e));
      if (done.isNotEmpty) found = {'sets': done, 'date': s['date']};
    }
  }
  return found;
}

class ToolStats {
  int sessions = 0;
  int sets = 0;
  double volume = 0;
  double minutes = 0;
  double km = 0;
  String? lastDate;
  final Map<String, Map<String, dynamic>> perExercise = {};
}

// Stats for one tool over all sessions — the React toolStats().
ToolStats toolStats(List<Map<String, dynamic>> sessions, Set<String> exerciseIds) {
  final out = ToolStats();
  var lastAt = 0;
  for (final s in sessions) {
    var used = false;
    for (final e in ((s['exercises'] as List?) ?? []).whereType<Map>()) {
      final ex = Map<String, dynamic>.from(e);
      if (!exerciseIds.contains(ex['exerciseId'])) continue;
      final done = doneSets(ex);
      if (done.isEmpty) continue;
      used = true;
      final p = out.perExercise.putIfAbsent(ex['exerciseId'].toString(), () => {'sets': 0, 'volume': 0.0, 'minutes': 0.0, 'km': 0.0, 'lastDate': null});
      for (final set in done) {
        final v = _n(set['weight']) * _n(set['reps']);
        out.sets += 1;
        p['sets'] = (p['sets'] as int) + 1;
        out.volume += v;
        p['volume'] = (p['volume'] as double) + v;
        out.minutes += _n(set['minutes']);
        p['minutes'] = (p['minutes'] as double) + _n(set['minutes']);
        out.km += _n(set['km']);
        p['km'] = (p['km'] as double) + _n(set['km']);
      }
      p['lastDate'] = s['date'];
    }
    if (used) {
      out.sessions += 1;
      final at = (s['startedAt'] as num?)?.toInt() ?? 0;
      if (at >= lastAt) {
        lastAt = at;
        out.lastDate = s['date']?.toString();
      }
    }
  }
  out.km = (out.km * 10).round() / 10;
  return out;
}

bool trainedOn(List<Map<String, dynamic>> sessions, String day) =>
    sessions.any((s) => s['date'] == day && s['endedAt'] != null);

Map<String, dynamic> blankSet(String unit) {
  if (unit == 'cardio') return {'minutes': '', 'km': '', 'done': false};
  if (unit == 'time') return {'seconds': '', 'done': false};
  return {'weight': '', 'reps': '', 'done': false};
}

// An exercise ready to log; sets start from last time's weights.
Map<String, dynamic> makeExercise(Map<String, dynamic> exercise, List<Map<String, dynamic>> sessions) {
  final unit = (exercise['unit'] ?? 'kg').toString();
  final last = lastPerformance(sessions, exercise['id'].toString());
  List<Map<String, dynamic>> sets;
  if (last != null) {
    sets = (last['sets'] as List<Map<String, dynamic>>).map((s) {
      final b = blankSet(unit);
      if (unit != 'cardio' && unit != 'time') b['weight'] = s['weight'] ?? '';
      return b;
    }).toList();
  } else {
    sets = List.generate(unit == 'cardio' ? 1 : 3, (_) => blankSet(unit));
  }
  return {
    'exerciseId': exercise['id'],
    'unit': unit,
    'muscle': exercise['muscle'],
    'sets': sets,
  };
}

bool setComplete(Map<String, dynamic> set, String unit) {
  if (unit == 'cardio') return _n(set['minutes']) > 0;
  if (unit == 'time') return _n(set['seconds']) > 0;
  return _n(set['reps']) > 0;
}

// Drops unfinished sets and empty exercises, stamps the end time.
Map<String, dynamic> finishSession(Map<String, dynamic> session, int nowMs) {
  final exercises = <Map<String, dynamic>>[];
  for (final e in ((session['exercises'] as List?) ?? []).whereType<Map>()) {
    final ex = Map<String, dynamic>.from(e);
    final unit = (ex['unit'] ?? 'kg').toString();
    final sets = ((ex['sets'] as List?) ?? [])
        .whereType<Map>()
        .map((s) => Map<String, dynamic>.from(s))
        .where((s) => s['done'] == true && setComplete(s, unit))
        .toList();
    if (sets.isNotEmpty) {
      ex['sets'] = sets;
      exercises.add(ex);
    }
  }
  return {...session, 'exercises': exercises, 'endedAt': nowMs};
}
