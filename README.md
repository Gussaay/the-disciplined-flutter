# the_disciplined

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Migration status (2026-11-23)

All four milestones are in:

- **M1** — scaffold, theme, Home with hero, glass stats and the services grid.
- **M2** — Food: the full 113-food database, the trainer's 2,800 kcal plan wired into the log, water, the AI coach (own Gemini/Groq key), profile-driven targets, Settings.
- **M3** — Gym: the 27-tool catalogue with the real photographs, per-tool dashboards (muscles, set-up, descriptions, stats), live session tracking and programmes. Watch: the GloryFit/LS02 Bluetooth protocol for the GZCSW02 (heart, blood pressure, oxygen, steps, battery, controls) with the standard heart-rate service as fallback. Scale: Chipsea broadcast parsing (the Yoda1 included) with body composition.
- **M4** — Prayer times computed on-device (adhan) with the prayer log, the Quran reader and Azkar (texts read from the same public files as the React edition and cached), family & friends with keep-in-touch rhythms, English study with Leitner-box word reviews, tasks, and the commitment dashboard.

Data lives on the device under the same store names and shapes as the React edition ('foodLog', 'gymSessions', 'prayerLog', 'weightLog', ...). Firebase sync is the one piece still to come: it needs the app registered in the Firebase console (google-services.json) before the two editions can share one account.

## Free over-the-air updates

Every build is published to a GitHub Release with `app-release.apk` and a small `update.json` beside it. The permanent direct link is:

https://github.com/Gussaay/the-disciplined-flutter/releases/latest/download/app-release.apk

The app checks `update.json` from Settings ("Check for updates") and offers the new APK directly — no store and no paid service involved.
