import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/app_controller.dart';

/// Section scaffold — the Flutter counterpart of the React app's Page:
/// a sticky header, a gradient banner in the goal's colours with its
/// motto, then the section's content.
///
/// Milestone 1 ships this shell for every section with an honest note
/// about what is being ported next; each section's real tools land in
/// their own milestone (see README roadmap).
class ShellPage extends StatelessWidget {
  const ShellPage({
    super.key,
    required this.titleEn,
    required this.titleAr,
    required this.mottoEn,
    required this.mottoAr,
    required this.color,
    required this.dark,
    required this.icon,
    required this.milestoneNoteEn,
    required this.milestoneNoteAr,
  });

  final String titleEn;
  final String titleAr;
  final String mottoEn;
  final String mottoAr;
  final Color color;
  final Color dark;
  final IconData icon;
  final String milestoneNoteEn;
  final String milestoneNoteAr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L(titleEn, titleAr),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
          tooltip: L('Back', 'رجوع'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, dark],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L(titleEn, titleAr).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        L(mottoEn, mottoAr),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  icon,
                  color: Colors.white.withValues(alpha: 0.85),
                  size: 44,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Icon(icon, size: 40, color: color),
                  const SizedBox(height: 10),
                  Text(
                    L(titleEn, titleAr),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    L(milestoneNoteEn, milestoneNoteAr),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
