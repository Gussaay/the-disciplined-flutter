import 'dart:convert';

import 'package:http/http.dart' as http;

/// Free over-the-air updates for the Flutter edition: every build is
/// published to a GitHub Release with a small update.json beside the
/// APK. The app reads that manifest, and when a newer build exists it
/// offers the direct APK link — no store, no paid service.
const String kAppVersion = '1.2.1';
const int kAppBuild = 4;

const String kUpdateManifestUrl =
    'https://github.com/Gussaay/the-disciplined-flutter/releases/latest/download/update.json';
const String kApkUrl =
    'https://github.com/Gussaay/the-disciplined-flutter/releases/latest/download/app-release.apk';

class UpdateInfo {
  const UpdateInfo({required this.version, required this.build, required this.apk, this.notes = ''});
  final String version;
  final int build;
  final String apk;
  final String notes;

  bool get isNewer => build > kAppBuild;
}

/// The available update, or null when up to date / unreachable.
Future<UpdateInfo?> checkForUpdate() async {
  try {
    final res = await http.get(Uri.parse(kUpdateManifestUrl));
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return UpdateInfo(
      version: (data['version'] ?? '').toString(),
      build: (data['build'] as num?)?.toInt() ?? 0,
      apk: (data['apk'] ?? kApkUrl).toString(),
      notes: (data['notes'] ?? '').toString(),
    );
  } catch (_) {
    return null;
  }
}
