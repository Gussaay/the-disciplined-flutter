import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'food_controller.dart';
import 'trainer_plan.dart';

class CoachNoKey implements Exception {
  const CoachNoKey();
}

/// The AI coach (milestone 2): builds the same facts block as the React
/// edition's coach (today vs the 2,800 kcal target, plan adherence,
/// water, the week's calories) and asks the user's own AI key — Gemini
/// first, Groq as backup, the same order and models as the React app.
/// Keys live on the device only, in the 'aiKeys' store, set in Settings.
class AiCoach {
  static const _geminiModels = ['gemini-flash-latest', 'gemini-2.5-flash'];
  static const _groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const _groqModel = 'llama-3.3-70b-versatile';

  static String facts(FoodController c, {required bool arabic}) {
    final t = c.totals;
    final tg = c.targets;
    final planLines = <String>[];
    for (final meal in kPlanMeals) {
      final pick = c.picks[meal.id];
      planLines.add(
        '- ${meal.en}: ${pick == null ? 'no option chosen' : 'option ${pick + 1} chosen, ${c.eatenMeals[meal.id] == true ? 'ticked eaten' : 'not yet ticked eaten'}'}',
      );
    }
    final week = c.last7DaysKcal();
    return '''
Today so far:
- Calories: ${t['kcal']!.round()} of ${tg['kcal']!.round()} kcal target
- Protein: ${t['protein']} g of ${tg['protein']!.round()} g
- Carbs: ${t['carbs']} g, fat: ${t['fat']} g, sugar: ${t['sugar']} g, fibre: ${t['fiber']} g
- Water: ${c.waterMl.value} ml of $kPlanWaterMl ml
Trainer's plan (2,800 kcal, one option per meal):
${planLines.join('\n')}
Last 7 days' calories (oldest first): ${week.join(', ')}
Profile weight: ${c.profile['weight'] ?? 'not set'} kg. Goal: gain weight as muscle mass.''';
  }

  static Future<String> analyse(FoodController c, {required bool arabic}) async {
    final keys = GetStorage().read<Map>('aiKeys') ?? {};
    final gemini = (keys['gemini'] ?? '').toString().trim();
    final groq = (keys['groq'] ?? '').toString().trim();
    if (gemini.isEmpty && groq.isEmpty) throw const CoachNoKey();

    final system =
        'You are the nutrition coach inside a goals app. The user follows a trainer\'s 2,800 kcal plan to gain weight as muscle mass. '
        'Analyse the facts and answer with four short headed sections: 1) Adherence to the plan, 2) Calories and protein vs target, '
        '3) Tips to gain muscle, 4) One thing to fix next. Be concrete and brief. No medical diagnosis. '
        'Answer in ${arabic ? 'Arabic' : 'English'}.';
    final user = facts(c, arabic: arabic);

    if (gemini.isNotEmpty) {
      for (final model in _geminiModels) {
        try {
          final res = await http
              .post(
                Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$gemini'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'system_instruction': {
                    'parts': [
                      {'text': system},
                    ],
                  },
                  'contents': [
                    {
                      'parts': [
                        {'text': user},
                      ],
                    },
                  ],
                }),
              )
              .timeout(const Duration(seconds: 60));
          if (res.statusCode == 200) {
            final body = jsonDecode(res.body) as Map<String, dynamic>;
            final candidates = body['candidates'] as List?;
            final parts = (candidates?.first['content']?['parts'] as List?) ?? [];
            final text = parts.map((p) => (p as Map)['text'] ?? '').join();
            if (text.trim().isNotEmpty) return text.trim();
          }
        } catch (_) {
          // try the next model, then Groq
        }
      }
    }
    if (groq.isNotEmpty) {
      final res = await http
          .post(
            Uri.parse(_groqUrl),
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $groq'},
            body: jsonEncode({
              'model': _groqModel,
              'messages': [
                {'role': 'system', 'content': system},
                {'role': 'user', 'content': user},
              ],
            }),
          )
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final choices = body['choices'] as List?;
        final text = (choices?.first['message']?['content'] ?? '').toString();
        if (text.trim().isNotEmpty) return text.trim();
      }
    }
    throw Exception('The AI did not answer');
  }
}
