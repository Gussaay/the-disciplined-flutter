# The Disciplined — Flutter edition: readiness note

Milestone 1 is complete and verified locally. This tree is ready to become
the first commit of the `the-disciplined-flutter` repository.

## Toolchain used

- Flutter **3.50.1** (channel stable), Dart SDK **3.14.0**
- Scaffold: `flutter create --project-name the_disciplined --org com.the.disciplined --platforms=android`
- Dependencies (see pubspec.yaml / pubspec.lock): get ^4.7.3, get_storage ^2.1.1,
  google_fonts ^9.0.0, cupertino_icons, flutter_lints

## Verification

- `dart format lib/` — applied (9 files).
- `flutter analyze` — **"No issues found!" (exit 0)**.
- No APK was built: this VM has no Android SDK. Analysis is the verification
  for this milestone; the first `flutter build apk` should run on a machine
  with the Android toolchain installed.

## What is in the tree (47 files)

- `lib/` — the milestone-1 app, replacing the template:
  - `main.dart` — GetMaterialApp, portrait lock, brand status bar, AppController registered
  - `app/theme.dart` — design tokens ported from the React app (pine/gold brand,
    semantic success/warning/danger, hero gradient, per-goal colours, Tajawal type)
  - `app/routes.dart` — route names mirroring the React edition's paths one-for-one;
    Home is real, the other 12 sections are honest shells with their porting milestone noted
  - `data/app_controller.dart` — GetX controller reading today's numbers from local
    storage under the React app's store names (profile, foodLog, water, weightLog, watchLog)
  - `widgets/hero_header.dart` — gradient hero, gold bloom, commitment ring, 7-day bars,
    four glass stat tiles (steps / kcal / water / weight)
  - `widgets/services_grid.dart` — the 12-tile "All sections" grid, one icon language
  - `widgets/skeleton.dart` — shimmer loading placeholder
  - `pages/home_page.dart`, `pages/shell_page.dart`
- `android/` — template scaffold with the identity changed (below).
- `pubspec.yaml` + `pubspec.lock` — lock included so versions reproduce exactly.
- `analysis_options.yaml` — flutter_lints plus one documented exception (below).
- The template's `test/` was removed (it tested the template's counter app).

## Android identity

- `applicationId` and `namespace`: **com.the.disciplined.flutter**
  (android/app/build.gradle.kts)
- App label: **"The Disciplined (Flutter)"** (android/app/src/main/AndroidManifest.xml),
  so it installs beside the React app without replacing it.
- MainActivity package moved to `com/the/disciplined/flutter/MainActivity.kt`.

## Fixes made during the first compile

Flutter 3.50 sits mid-transition between `package:flutter/material.dart` and
`package:material_ui`: the two libraries define **incompatible TextTheme
classes**, and the ecosystem is split across them (GetX types against
material.dart; google_fonts' generated code types against material_ui).

1. `GoogleFonts.tajawalTextTheme(...)` does not compile against the SDK's
   ThemeData in this split. theme.dart now applies Tajawal through
   `ThemeData(fontFamily: GoogleFonts.tajawal().fontFamily)` — a plain
   string, so no cross-library type assignment happens.
2. Staying on material.dart (required by GetX) surfaces a
   `deprecated_member_use` info for the material import in every file, which
   this Flutter version treats as a failed analyze. analysis_options.yaml
   silences **only that one diagnostic**, with a comment explaining why and
   when to remove it (when GetX migrates to material_ui).

## The one remaining step

1. Easy creates the empty GitHub repository **`the-disciplined-flutter`**
   (the GitHub App cannot create repos — it returned 403) and makes sure the
   Muse GitHub App installation covers it.
2. Push this tree as the first commit, as-is.

⚠️ **Binary files:** the connector's push-files is text-only. Six files in
this tree are binary and cannot go through it:

- `android/app/src/main/res/mipmap-*/ic_launcher.png` (5 launcher icons)
- `android/gradle/wrapper/gradle-wrapper.jar`

Push them via a normal local git checkout, or drop them from the snapshot
push and regenerate on the build machine with `flutter create .` in the
repo root (which restores the template icons and wrapper jar; the branded
launcher icon is a later milestone anyway). Everything else is text and
pushes cleanly.
