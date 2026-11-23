import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../gym_logic.dart';

/// Gym state (milestone 3): finished sessions in 'gymSessions' and the
/// workout in progress in 'gymActive', the React edition's stores.
class GymController extends GetxController {
  final box = GetStorage();
  final sessions = <Map<String, dynamic>>[].obs;
  final active = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    final s = box.read<List>('gymSessions');
    if (s != null) {
      sessions.assignAll(s.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList());
    }
    final a = box.read<Map>('gymActive');
    if (a != null) active.value = Map<String, dynamic>.from(a);
  }

  void _saveSessions() => box.write('gymSessions', sessions.toList());

  /// Persist the active session after in-place edits (the session page
  /// edits the map directly to keep text-field focus).
  void persistActive() => _saveActive();
  void _saveActive() {
    if (active.value == null) {
      box.remove('gymActive');
    } else {
      box.write('gymActive', active.value);
    }
  }

  void startSession(String name, List<Map<String, dynamic>> exercises) {
    final now = DateTime.now();
    active.value = {
      'id': now.microsecondsSinceEpoch.toString(),
      'date': '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      'startedAt': now.millisecondsSinceEpoch,
      'name': name,
      'exercises': exercises.map((e) => makeExercise(e, sessions)).toList(),
    };
    _saveActive();
  }

  void mutateActive(void Function(Map<String, dynamic>) fn) {
    final a = active.value;
    if (a == null) return;
    fn(a);
    active.value = Map<String, dynamic>.from(a);
    _saveActive();
  }

  void addExerciseToActive(Map<String, dynamic> exercise) {
    mutateActive((a) {
      final list = ((a['exercises'] as List?) ?? []).cast<Map<String, dynamic>>();
      list.add(makeExercise(exercise, sessions));
      a['exercises'] = list;
    });
  }

  void finishActive() {
    final a = active.value;
    if (a == null) return;
    final done = finishSession(a, DateTime.now().millisecondsSinceEpoch);
    if ((done['exercises'] as List).isNotEmpty) {
      sessions.add(done);
      _saveSessions();
    }
    active.value = null;
    _saveActive();
  }

  void discardActive() {
    active.value = null;
    _saveActive();
  }
}
