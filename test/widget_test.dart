// Milestone-1 tests for the Flutter edition.
//
// This file replaces the counter test that `flutter create` generates
// (it referenced the template's MyApp, which this app never had — that
// stale file is what failed the first CI build's analyze step). The
// tests below verify what milestone 1 actually promises: the route map
// mirrors the React edition one-for-one, the brand tokens match the
// React design system, and the Home services grid covers every section.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_disciplined/app/routes.dart';
import 'package:the_disciplined/app/theme.dart';
import 'package:the_disciplined/widgets/services_grid.dart';

void main() {
  test('route map mirrors the React edition paths', () {
    final names = AppPages.pages.map((p) => p.name).toSet();
    expect(
      names,
      containsAll(<String>{
        AppRoutes.home,
        AppRoutes.gym,
        AppRoutes.food,
        AppRoutes.prayer,
        AppRoutes.quran,
        AppRoutes.azkar,
        AppRoutes.social,
        AppRoutes.english,
        AppRoutes.tasks,
        AppRoutes.weight,
        AppRoutes.watch,
        AppRoutes.dashboard,
        AppRoutes.settings,
      }),
    );
    expect(names, hasLength(13));
  });

  test('brand tokens match the React design system', () {
    expect(Brand.pine800, const Color(0xFF0F3D3E));
    expect(Brand.gold500, const Color(0xFFC99A22));
    expect(Brand.paper, const Color(0xFFF6F3EC));
    final theme = buildLightTheme();
    expect(theme.colorScheme.primary, Brand.pine800);
    expect(theme.scaffoldBackgroundColor, Brand.paper);
  });

  test('services grid covers twelve sections, all routed', () {
    expect(kServices, hasLength(12));
    final routed = AppPages.pages.map((p) => p.name).toSet();
    for (final s in kServices) {
      expect(routed, contains(s.route), reason: '${s.labelEn} route missing');
    }
  });

  testWidgets('themed app shell renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: const Scaffold(body: Center(child: Text('The Disciplined'))),
      ),
    );
    expect(find.text('The Disciplined'), findsOneWidget);
  });
}
