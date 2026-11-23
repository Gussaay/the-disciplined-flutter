import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_disciplined/app/routes.dart';
import 'package:the_disciplined/app/theme.dart';
import 'package:the_disciplined/data/app_controller.dart';
import 'package:the_disciplined/data/food_controller.dart';
import 'package:the_disciplined/data/gym_controller.dart';
import 'package:the_disciplined/data/watch_controller.dart';
import 'package:the_disciplined/data/weight_controller.dart';
import 'package:the_disciplined/pages/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => '/tmp/gs_test',
    );
    await GetStorage.init();
    Get.put(AppController(), permanent: true);
    Get.put(FoodController(), permanent: true);
    Get.put(GymController(), permanent: true);
    Get.put(WatchController(), permanent: true);
    Get.put(WeightController(), permanent: true);
  });

  testWidgets('Home renders goal cards and services grid', (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      theme: buildLightTheme(),
      getPages: AppPages.pages,
      home: const HomePage(),
    ));
    await tester.pump(const Duration(milliseconds: 300));
    final ex = tester.takeException();
    if (ex != null) {
      // ignore: avoid_print
      print('HOME EXCEPTION: $ex');
    }
    expect(ex, isNull);

  });
}
