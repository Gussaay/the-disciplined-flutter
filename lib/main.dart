import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes.dart';
import 'app/theme.dart';
import 'data/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Brand.pine800),
  );
  Get.put(AppController(), permanent: true);
  runApp(const DisciplinedApp());
}

/// The Disciplined — Flutter edition.
///
/// Built in parallel with the React edition: same Firebase backend, same
/// design tokens, same route map. The React app stays the production app
/// until this edition reaches parity and a decision is made.
class DisciplinedApp extends StatelessWidget {
  const DisciplinedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'The Disciplined',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en'),
      defaultTransition: Transition.fadeIn,
    );
  }
}
