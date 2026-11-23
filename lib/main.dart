import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes.dart';
import 'app/theme.dart';
import 'data/app_controller.dart';
import 'data/food_controller.dart';
import 'data/gym_controller.dart';
import 'data/watch_controller.dart';
import 'data/weight_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Brand.pine800),
  );
  Get.put(AppController(), permanent: true);
  Get.put(FoodController(), permanent: true);
  Get.put(GymController(), permanent: true);
  Get.put(WatchController(), permanent: true);
  Get.put(WeightController(), permanent: true);
  final savedTheme = GetStorage().read<String>('themeMode') ?? 'system';
  runApp(DisciplinedApp(
    themeMode: savedTheme == 'dark'
        ? ThemeMode.dark
        : savedTheme == 'light'
            ? ThemeMode.light
            : ThemeMode.system,
  ));
}

/// The Disciplined — Flutter edition.
///
/// Built in parallel with the React edition: same Firebase backend, same
/// design tokens, same route map. The React app stays the production app
/// until this edition reaches parity and a decision is made.
class DisciplinedApp extends StatelessWidget {
  const DisciplinedApp({super.key, this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'The Disciplined',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en'),
      defaultTransition: Transition.fadeIn,
    );
  }
}
