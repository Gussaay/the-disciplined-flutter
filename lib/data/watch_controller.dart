import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../ls02.dart';
import 'app_controller.dart';

String _hex(List<int> b) => b.map((x) => x.toRadixString(16).padLeft(2, '0')).join(' ');

/// The watch link (milestone 3): Bluetooth LE to Realtek/LS02 watches
/// (Easy's GZCSW02) speaking the GloryFit protocol, with the standard
/// Heart Rate service as a read-only fallback — the React edition's
/// three protocol levels, on flutter_blue_plus.
class WatchController extends GetxController {
  final box = GetStorage();

  final scanning = false.obs;
  final devices = <ScanResult>[].obs;
  final connected = false.obs;
  final deviceName = ''.obs;
  final status = ''.obs;
  final battery = RxnInt();
  final stepsToday = RxnInt();
  final heart = RxnInt();
  final heartAt = Rxn<DateTime>();
  final bpSys = RxnInt();
  final bpDia = RxnInt();
  final spo2 = RxnInt();
  final log = <String>[].obs;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _writeChar;
  BluetoothCharacteristic? _hrChar;
  final Map<int, int> _hourSteps = {};
  final List<StreamSubscription> _subs = [];
  bool _isLs02 = false;

  void _log(String line) {
    log.insert(0, line);
    if (log.length > 200) log.removeRange(200, log.length);
  }

  Future<void> startScan() async {
    devices.clear();
    scanning.value = true;
    _subs.add(FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final i = devices.indexWhere((d) => d.device.remoteId == r.device.remoteId);
        if (i >= 0) {
          devices[i] = r;
        } else {
          devices.add(r);
        }
      }
    }));
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      status.value = 'Scan failed: $e';
    }
    scanning.value = false;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    scanning.value = false;
  }

  Future<void> connectTo(ScanResult result) async {
    await stopScan();
    final device = result.device;
    _device = device;
    deviceName.value = result.advertisementData.advName.isNotEmpty ? result.advertisementData.advName : device.platformName;
    status.value = 'Connecting…';
    try {
      await device.connect(license: License.free, timeout: const Duration(seconds: 20));
      // GloryFit bonds at link time; control orders may need a bonded link.
      if (Platform.isAndroid) {
        try {
          await device.createBond(timeout: 15);
        } catch (_) {
          // Already bonded, or the watch refused: carry on either way.
        }
      }
      final services = await device.discoverServices();
      final uuids = services.map((s) => s.uuid.toString().toLowerCase()).toList();
      _isLs02 = uuids.contains(Ls02Uuids.general) && uuids.contains(Ls02Uuids.data);
      BluetoothCharacteristic? hrNotify;
      for (final s in services) {
        for (final c in s.characteristics) {
          final u = c.uuid.toString().toLowerCase();
          if (u == Ls02Uuids.generalWrite) _writeChar = c;
          if (u == Ls02Uuids.generalNotify || u == Ls02Uuids.dataNotify || u.endsWith('34f2') || u.endsWith('6102')) {
            await _subscribe(c);
          }
          if (u == '00002a37-0000-1000-8000-00805f9b34fb') hrNotify = c;
        }
      }
      if (!_isLs02 && hrNotify != null) {
        _hrChar = hrNotify;
        await hrNotify.setNotifyValue(true);
        _subs.add(hrNotify.onValueReceived.listen(_onHeartRateService));
        status.value = 'Connected (heart-rate only)';
      } else if (_writeChar != null) {
        status.value = 'Connected';
      } else {
        status.value = 'Connected (no control channel found)';
      }
      connected.value = true;
      box.write('watch', {'id': device.remoteId.toString(), 'name': deviceName.value});
      _log('· connected to ${deviceName.value}');
      if (_isLs02) {
        await send(Ls02Cmd.time());
        await send(Ls02Cmd.format());
        await send(Ls02Cmd.battery());
        await send(Ls02Cmd.steps());
      }
    } catch (e) {
      status.value = 'Connection failed: $e';
      connected.value = false;
    }
  }

  Future<void> _subscribe(BluetoothCharacteristic c) async {
    try {
      await c.setNotifyValue(true);
      _subs.add(c.onValueReceived.listen(_onData));
    } catch (_) {}
  }

  void _onHeartRateService(List<int> v) {
    if (v.length < 2) return;
    final bpm = (v[0] & 0x01) != 0 ? (v[1] | (v[2] << 8)) : v[1];
    if (bpm > 25 && bpm < 230) {
      heart.value = bpm;
      heartAt.value = DateTime.now();
      _log('← heart $bpm bpm (standard service)');
    }
  }

  void _onData(List<int> v) {
    _log('← ${_hex(v)}');
    final r = parseLs02(v, steps: _hourSteps);
    if (r == null) return;
    switch (r['type']) {
      case 'battery':
        battery.value = r['level'] as int;
        break;
      case 'heart':
        heart.value = r['bpm'] as int;
        heartAt.value = DateTime.now();
        break;
      case 'bp':
        bpSys.value = r['systolic'] as int;
        bpDia.value = r['diastolic'] as int;
        break;
      case 'spo2':
        spo2.value = r['spo2'] as int;
        break;
      case 'day':
        stepsToday.value = r['steps'] as int;
        _saveWatchLog();
        break;
      case 'stepsRow':
        // The day total arrives with the 0xfd end marker.
        break;
    }
  }

  void _saveWatchLog() {
    final now = DateTime.now();
    final key = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final all = Map<String, dynamic>.from(box.read<Map>('watchLog') ?? {});
    final day = Map<String, dynamic>.from(all[key] is Map ? all[key] as Map : {});
    if (stepsToday.value != null) day['steps'] = stepsToday.value;
    if (battery.value != null) day['battery'] = battery.value;
    if (heart.value != null) day['heart'] = heart.value;
    all[key] = day;
    box.write('watchLog', all);
    if (Get.isRegistered<AppController>()) {
      final app = Get.find<AppController>();
      if (stepsToday.value != null) app.stepsToday.value = stepsToday.value;
    }
  }

  Future<void> send(List<int> cmd) async {
    final c = _writeChar;
    if (c == null) return;
    _log('→ ${_hex(cmd)}');
    try {
      await c.write(cmd, withoutResponse: false);
    } catch (_) {
      try {
        await c.write(cmd, withoutResponse: true);
      } catch (e) {
        _log('· write failed: $e');
      }
    }
  }

  /// Heart measurement with the GloryFit retry pattern: resend E5 11
  /// every 6 seconds, up to 3 times, until a reading lands.
  Future<void> measureHeart() async {
    final before = heartAt.value;
    for (var i = 0; i < 3; i++) {
      await send(Ls02Cmd.heartStart());
      for (var w = 0; w < 12; w++) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (heartAt.value != before && heartAt.value != null) return;
      }
    }
  }

  Future<void> stopHeart() => send(Ls02Cmd.heartStop());
  Future<void> measureBp() => send(Ls02Cmd.bpStart());
  Future<void> stopBp() => send(Ls02Cmd.bpStop());
  Future<void> measureSpo2() => send(Ls02Cmd.spo2Start());
  Future<void> stopSpo2() => send(Ls02Cmd.spo2Stop());
  Future<void> refreshBasics() async {
    await send(Ls02Cmd.battery());
    await send(Ls02Cmd.steps());
  }

  Future<void> disconnect() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    await _device?.disconnect();
    connected.value = false;
    status.value = '';
    _writeChar = null;
    _hrChar = null;
  }

  @override
  void onClose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.onClose();
  }
}
