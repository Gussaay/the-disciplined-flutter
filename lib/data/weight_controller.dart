import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../body_comp.dart';
import '../scale_parse.dart';
import 'app_controller.dart';
import 'food_controller.dart';

/// The scale link (milestone 3): Chipsea scales broadcast the reading
/// in their advertisements, so weighing in is a scan, not a connection.
/// Settled readings save into 'weightLog', the React edition's store.
class WeightController extends GetxController {
  final box = GetStorage();

  final scanning = false.obs;
  final reading = Rxn<ScaleReading>();
  final scaleName = ''.obs;
  final settled = false.obs;
  final encryptedSeen = false.obs;
  final history = <Map<String, dynamic>>[].obs;

  final ScaleSettler _settler = ScaleSettler();
  StreamSubscription? _sub;
  bool _savedThisSession = false;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void _loadHistory() {
    final list = box.read<List>('weightLog');
    if (list != null) {
      history.assignAll(list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList());
    }
  }

  Future<void> startScan() async {
    reading.value = null;
    settled.value = false;
    encryptedSeen.value = false;
    _savedThisSession = false;
    _settler.reset();
    scanning.value = true;
    _sub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final mfr = <int, Uint8List>{};
        r.advertisementData.manufacturerData.forEach((k, v) {
          mfr[k] = Uint8List.fromList(v);
        });
        if (mfr.isEmpty) continue;
        final parsed = parseAdvert(mfr);
        if (parsed == null) continue;
        scaleName.value = r.advertisementData.advName.isNotEmpty ? r.advertisementData.advName : r.device.platformName;
        if (parsed.encrypted) {
          encryptedSeen.value = true;
          continue;
        }
        reading.value = parsed;
        if (_settler.push(parsed, DateTime.now().millisecondsSinceEpoch) && !_savedThisSession) {
          _savedThisSession = true;
          settled.value = true;
          saveReading(parsed);
        }
      }
    });
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 30));
    } catch (_) {}
    scanning.value = false;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await _sub?.cancel();
    scanning.value = false;
  }

  Map<String, dynamic> _profile() {
    if (Get.isRegistered<FoodController>()) return Get.find<FoodController>().profile;
    return {};
  }

  void saveReading(ScaleReading r) {
    if (r.weight == null) return;
    final p = _profile();
    final comp = bodyComposition(
      weight: r.weight!,
      impedance: r.impedance,
      height: (p['height'] as num?)?.toDouble() ?? 170,
      age: (p['age'] as num?)?.toDouble() ?? 30,
      sex: (p['sex'] ?? 'male').toString(),
    );
    final now = DateTime.now();
    history.add({
      'date': FoodController.dayKey(now),
      'ts': now.millisecondsSinceEpoch,
      ...comp,
    });
    box.write('weightLog', history.toList());
    if (Get.isRegistered<AppController>()) {
      Get.find<AppController>().lastWeightKg.value = r.weight;
    }
  }

  void addManual(double kg) {
    saveReading(ScaleReading(format: 'manual', weight: kg));
    settled.value = true;
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
