// B2 lessons for the English plan, ported from the React edition's
// src/data/lessons.js (same content, same exercise ids — the ids are
// recorded in the english log, so they must stay identical across
// editions).

class BiText {
  const BiText(this.en, this.ar);
  final String en;
  final String ar;
}

class LessonExercise {
  const LessonExercise({
    required this.id,
    required this.title,
    required this.minutes,
    required this.instructions,
    this.lines = const [],
    this.prompts = const [],
  });
  final String id;
  final BiText title;
  final int minutes;
  final BiText instructions;
  final List<BiText> lines;
  final List<BiText> prompts;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.skill,
    required this.level,
    required this.title,
    required this.minutes,
    required this.intro,
    required this.steps,
    required this.phrases,
    required this.exercises,
  });
  final String id;
  final String skill;
  final String level;
  final BiText title;
  final int minutes;
  final BiText intro;
  final List<BiText> steps;
  final List<BiText> phrases;
  final List<LessonExercise> exercises;
}

const List<Lesson> kLessons = [
  Lesson(
    id: 'b2-shadowing', skill: 'shadowing', level: 'B2',
    title: BiText('Shadow like a native speaker', 'حاكِ كالناطق الأصلي'), minutes: 25,
    intro: BiText('Shadowing means listening to a native speaker and repeating what they say at the same time, half a second behind them, like an echo. You copy not only the words but the music of the language: stress, rhythm, pauses and melody. At B2 your grammar and vocabulary are already strong; shadowing is what turns that knowledge into fluent, natural speech, because your mouth learns the patterns your ears already know.', 'المحاكاة الصوتية تعني أن تستمع إلى ناطق أصلي وتردد ما يقوله في اللحظة نفسها، متأخراً عنه بنصف ثانية، كأنك صدى صوته. أنت لا تقلد الكلمات فقط، بل موسيقى اللغة: النبر والإيقاع والوقفات والنغمة. في مستوى B2 قواعدك ومفرداتك قوية أصلاً، والمحاكاة هي ما يحوّل هذه المعرفة إلى كلام طبيعي وطلق، لأن فمك يتعلم الأنماط التي تعرفها أذنك أصلاً.'),
    steps: [BiText('Listen once without speaking. Follow the text and just hear the melody.', 'استمع مرة واحدة دون أن تتكلم. تابع النص وأنصت للنغمة فقط.'), BiText('Listen again and mark the chunks: draw a line where the speaker pauses, and underline the stressed words.', 'استمع مرة أخرى وحدّد المقاطع: ارسم خطاً حيث يتوقف المتحدث وضع خطاً تحت الكلمات المنبورة.'), BiText('Whisper-shadow: play it again and repeat half a second behind the speaker, quietly, keeping their rhythm.', 'حاكِ هامساً: شغّل التسجيل وكرر متأخراً بنصف ثانية وبصوت منخفض مع الحفاظ على إيقاع المتحدث.'), BiText('Full-voice shadow: repeat at normal volume, matching the stress and the melody, not just the words.', 'حاكِ بصوت كامل: كرر بصوت طبيعي وطابِق النبر والنغمة، لا الكلمات فقط.'), BiText('Record yourself shadowing, then listen to the original and your version back to back. Repeat the chunks that still sound different.', 'سجّل نفسك أثناء المحاكاة، ثم استمع إلى الأصل وإلى تسجيلك متتاليين. كرر المقاطع التي ما زالت تبدو مختلفة.')],
    phrases: [BiText('as a result of this', 'نتيجةً لذلك'), BiText('in the long run', 'على المدى الطويل'), BiText('a growing number of people', 'عدد متزايد من الناس'), BiText('on the other hand', 'من ناحية أخرى'), BiText('the point is that…', 'المهم هو أن…'), BiText('what this means is…', 'ما يعنيه هذا هو…')],
    exercises: [
      LessonExercise(
        id: 'shadow-news', title: BiText('Shadow the news', 'حاكِ نشرة الأخبار'), minutes: 8,
        instructions: BiText('Read each line aloud at newsreader speed (or tap listen), then shadow it twice: once whispering, once at full voice. Keep the formal, falling melody of news English. At the end, shadow the whole bulletin without stopping.', 'اقرأ كل سطر بصوت عالٍ بسرعة مذيع الأخبار (أو اضغط زر الاستماع)، ثم حاكِه مرتين: مرة هامساً ومرة بصوت كامل. حافظ على نغمة الأخبار الرسمية الهابطة. وفي النهاية حاكِ النشرة كاملة دون توقف.'),
        lines: [BiText('Good evening. The city council has announced a new plan to cut waiting times at public hospitals.', 'مساء الخير. أعلن مجلس المدينة خطة جديدة لتقليل أوقات الانتظار في المستشفيات العامة.'), BiText('Under the plan, a growing number of clinics will stay open until ten in the evening.', 'وبموجب الخطة، سيبقى عدد متزايد من العيادات مفتوحاً حتى العاشرة مساءً.'), BiText('Officials say the change comes as a result of a survey of more than five thousand patients.', 'ويقول المسؤولون إن التغيير جاء نتيجة استطلاع شمل أكثر من خمسة آلاف مريض.'), BiText('Doctors have welcomed the decision, but they warn that more nurses will be needed.', 'وقد رحّب الأطباء بالقرار، لكنهم حذّروا من الحاجة إلى مزيد من الممرضين.'), BiText('On the other hand, some residents worry that smaller towns will be left behind.', 'ومن ناحية أخرى، يخشى بعض السكان أن تُترك البلدات الصغيرة خلف الركب.'), BiText('The health minister told reporters that no clinic would close under the new system.', 'وقال وزير الصحة للصحفيين إنه لن يُغلق أي عيادة في ظل النظام الجديد.'), BiText('In the long run, the government hopes the plan will bring care closer to people’s homes.', 'وعلى المدى الطويل، تأمل الحكومة أن يقرّب هذا المخطط الرعاية الصحية من بيوت الناس.'), BiText('The first changes begin next month, and a full report is expected by the end of the year.', 'وتبدأ التغييرات الأولى الشهر المقبل، ويُتوقع صدور تقرير كامل بنهاية العام.'), BiText('That is all from us tonight. Thank you for watching, and good night.', 'هذا كل ما لدينا الليلة. شكراً لمشاهدتكم، وتصبحون على خير.')],
      ),
      LessonExercise(
        id: 'shadow-talk', title: BiText('Shadow a talk, chunk by chunk', 'حاكِ محاضرة مقطعاً مقطعاً'), minutes: 9,
        instructions: BiText('This talk segment lasts 60–90 seconds and is already split into intonation chunks (the / marks show where the speaker breathes). Loop one chunk at a time: listen, whisper-shadow it three times, then say it at full voice. When every chunk feels easy, shadow the whole segment in one go and record it.', 'هذا المقطع من محاضرة مدته 60–90 ثانية ومقسّم أصلاً إلى مقاطع نغمية (علامة / تُظهر أين يتنفس المتحدث). كرر كل مقطع على حدة: استمع، حاكِه هامساً ثلاث مرات، ثم قله بصوت كامل. وعندما تصبح كل المقاطع سهلة، حاكِ المقطع كاملاً دفعة واحدة وسجّله.'),
        lines: [BiText('Most people believe / that talent decides / who learns a language well.', 'يعتقد أغلب الناس أن الموهبة هي التي تحدد من يتعلم لغة ما جيداً.'), BiText('But after twenty years of teaching, / I can tell you / that is simply not true.', 'لكن بعد عشرين عاماً من التدريس، أستطيع أن أقول لكم إن هذا ببساطة غير صحيح.'), BiText('The students who succeed / are not the most talented ones. / They are the most consistent ones.', 'الطلاب الذين ينجحون ليسوا الأكثر موهبة، بل الأكثر استمرارية.'), BiText('They practise a little / every single day, / even when they do not feel like it.', 'يتدربون قليلاً كل يوم، حتى عندما لا يرغبون في ذلك.'), BiText('Small steps, / repeated daily, / beat big efforts / once a month.', 'الخطوات الصغيرة المتكررة يومياً تتفوق على الجهود الكبيرة مرة في الشهر.'), BiText('So do not ask yourself / whether you are talented. / Ask whether you showed up today.', 'لذا لا تسأل نفسك إن كنت موهوباً، بل اسأل إن كنت قد حضرت اليوم.'), BiText('Because in the long run, / habits always win.', 'لأن العادات تنتصر دائماً على المدى الطويل.'), BiText('And the good news is: / anyone can build a habit.', 'والخبر السار هو أن أي شخص يستطيع بناء عادة.')],
      ),
      LessonExercise(
        id: 'shadow-dialogue', title: BiText('Shadow a dialogue: both parts', 'حاكِ حواراً: كلا الدورين'), minutes: 8,
        instructions: BiText('A workplace dialogue between a manager (Sara) and a team member (Omar). Shadow Sara’s lines first, then Omar’s, then play both parts in time with the recording. Notice how questions rise at the end and statements fall.', 'حوار في مكان العمل بين مديرة (سارة) وعضو في الفريق (عمر). حاكِ سطور سارة أولاً، ثم سطور عمر، ثم مثّل الدورين معاً في الوقت نفسه مع التسجيل. لاحظ كيف ترتفع النغمة في نهاية الأسئلة وتهبط في نهاية الجمل الخبرية.'),
        lines: [BiText('Sara: Morning, Omar. Have you got a minute? I’d like to talk about Friday’s deadline.', 'سارة: صباح الخير يا عمر. هل لديك دقيقة؟ أود أن نتحدث عن الموعد النهائي يوم الجمعة.'), BiText('Omar: Of course. Actually, that’s exactly what I wanted to raise with you.', 'عمر: بالتأكيد. في الحقيقة، هذا بالضبط ما أردت أن أثيره معك.'), BiText('Sara: The client has asked for the full report, not just the summary. Can we manage that?', 'سارة: طلب العميل التقرير الكامل، لا الملخص فقط. هل نستطيع إنجاز ذلك؟'), BiText('Omar: We can, but I’ll need one more day for the figures. They have to be checked twice.', 'عمر: نستطيع، لكنني سأحتاج إلى يوم إضافي من أجل الأرقام. يجب تدقيقها مرتين.'), BiText('Sara: That sounds reasonable. What if we send the summary on Friday and the full report on Monday?', 'سارة: هذا يبدو معقولاً. ما رأيك أن نرسل الملخص يوم الجمعة والتقرير الكامل يوم الاثنين؟'), BiText('Omar: That works for me. I’ll email the client today so there are no surprises.', 'عمر: يناسبني ذلك. سأراسل العميل اليوم حتى لا تكون هناك مفاجآت.'), BiText('Sara: Perfect. And Omar — thanks for flagging this early instead of struggling in silence.', 'سارة: ممتاز. وعمر — شكراً لأنك نبّهتني مبكراً بدلاً من أن تعاني في صمت.'), BiText('Omar: Lesson learned from last time, I suppose!', 'عمر: درس تعلمته من المرة الماضية، على ما أظن!'), BiText('Sara: Exactly. Right, let’s catch up again on Thursday and see where we are.', 'سارة: بالضبط. حسناً، لنتقابل مجدداً يوم الخميس ونرَ أين وصلنا.'), BiText('Omar: Thursday it is. I’ll bring the draft figures with me.', 'عمر: الخميس إذن. سأحضر مسودة الأرقام معي.')],
      ),
    ],
  ),
  Lesson(
    id: 'b2-communication', skill: 'communication', level: 'B2',
    title: BiText('Hold a real conversation', 'خُض محادثة حقيقية'), minutes: 30,
    intro: BiText('At B2 you can already say what you think. Communication is the next step: structuring your ideas so people can follow you, keeping a conversation alive with questions, and disagreeing without making it a fight. This lesson gives you one simple frame for opinions (PREP), phrase banks for the moves every conversation needs, and drills that turn them into habits.', 'في مستوى B2 تستطيع أصلاً أن تقول ما تفكر فيه. التواصل هو الخطوة التالية: أن ترتّب أفكارك ليتابعك الناس، وأن تُبقي المحادثة حية بالأسئلة، وأن تختلف دون أن يتحول الاختلاف إلى مشاجرة. تمنحك هذه الدرس إطاراً بسيطاً للآراء (PREP)، وبنوك عبارات للحركات التي تحتاجها كل محادثة، وتدريبات تحوّلها إلى عادات.'),
    steps: [BiText('PREP for opinions: Point — say your view in one sentence. Reason — say why. Example — give one real example. Point — repeat your view in different words.', 'إطار PREP للآراء: النقطة — قل رأيك في جملة واحدة. السبب — قل لماذا. المثال — أعطِ مثالاً حقيقياً واحداً. النقطة — كرر رأيك بكلمات مختلفة.'), BiText('Ask before you answer: one follow-up question (“What makes you say that?”) buys you time and makes the other person feel heard.', 'اسأل قبل أن تجيب: سؤال متابعة واحد («ما الذي يجعلك تقول ذلك؟») يمنحك الوقت ويجعل الطرف الآخر يشعر أنك تسمعه.'), BiText('Disagree in three moves: acknowledge (“I see your point”), soften (“but I wonder if…”), then give your view with PREP.', 'اختلف في ثلاث حركات: اعترف («أفهم وجهة نظرك»)، لطّف («لكن أتساءل إن…»)، ثم أعطِ رأيك بإطار PREP.'), BiText('Buy time honestly: “Let me think about that for a second” sounds far better than a long silence or a rushed answer.', 'اكسب الوقت بصدق: «دعني أفكر في ذلك لثانية» تبدو أفضل بكثير من صمت طويل أو إجابة متسرعة.'), BiText('Close topics gracefully: summarise what you both agreed (“So we both think…”) before moving on.', 'اختم المواضيع بلباقة: لخّص ما اتفقتما عليه («إذن كلانا يرى أن…») قبل الانتقال إلى غيره.')],
    phrases: [BiText('The way I see it…', 'من وجهة نظري…'), BiText('I take your point, but…', 'أفهم وجهة نظرك، لكن…'), BiText('I’d go along with that, as long as…', 'أوافق على ذلك، بشرط أن…'), BiText('I see it slightly differently.', 'أرى الأمر بصورة مختلفة قليلاً.'), BiText('Building on what you said…', 'بناءً على ما قلته…'), BiText('What makes you say that?', 'ما الذي يجعلك تقول ذلك؟'), BiText('Could you give me an example?', 'هل تستطيع أن تعطيني مثالاً؟'), BiText('How did that work out in the end?', 'وكيف انتهى الأمر في النهاية؟'), BiText('Let me think about that for a second.', 'دعني أفكر في ذلك لثانية.'), BiText('That’s a good question. I’d say…', 'هذا سؤال جيد. أقول إن…'), BiText('If I understood you correctly…', 'إذا فهمتك بصورة صحيحة…'), BiText('So we both agree that…', 'إذن كلانا متفق على أن…')],
    exercises: [
      LessonExercise(
        id: 'comm-opinion', title: BiText('The opinion ladder', 'سلّم الآراء'), minutes: 10,
        instructions: BiText('Pick one prompt. Speak about it for 30 seconds, rest, then speak on the same prompt for 1 minute, then for 2 minutes — climbing the ladder. Use PREP every time and record the 2-minute round. If you get stuck, use a buying-time phrase, never silence.', 'اختر سؤالاً واحداً. تحدث عنه 30 ثانية، استرح، ثم تحدث عن السؤال نفسه دقيقة واحدة، ثم دقيقتين — صاعداً السلّم. استخدم إطار PREP في كل مرة وسجّل جولة الدقيقتين. إذا علقت، استخدم عبارة لكسب الوقت، ولا تصمت أبداً.'),
        prompts: [BiText('Should companies move to a four-day working week?', 'هل ينبغي للشركات الانتقال إلى أسبوع عمل من أربعة أيام؟'), BiText('Is artificial intelligence a threat or an opportunity for young workers?', 'هل الذكاء الاصطناعي تهديد أم فرصة للعمال الشباب؟'), BiText('Should university education be free for everyone?', 'هل ينبغي أن يكون التعليم الجامعي مجانياً للجميع؟')],
      ),
      LessonExercise(
        id: 'comm-roleplay', title: BiText('Role-play cards', 'بطاقات لعب الأدوار'), minutes: 12,
        instructions: BiText('Pick a card. Read your goal, then play the scene aloud — both parts if you are alone, or with a partner if you can. The scene only counts if you use at least three phrases from the phrase bank above.', 'اختر بطاقة. اقرأ هدفك، ثم مثّل المشهد بصوت عالٍ — الدورين إن كنت وحدك، أو مع شريك إن استطعت. لا يُحتسب المشهد إلا إذا استخدمت ثلاث عبارات على الأقل من بنك العبارات أعلاه.'),
        prompts: [BiText('Card 1 — Team meeting: the project is two weeks late. Your goal: explain the delay honestly and agree a new deadline. Useful phrases: “The way I see it…”, “Building on what you said…”, “So we both agree that…”', 'البطاقة 1 — اجتماع فريق: تأخر المشروع أسبوعين. هدفك: اشرح التأخير بصدق واتفق على موعد جديد. عبارات مفيدة: «من وجهة نظري…»، «بناءً على ما قلته…»، «إذن كلانا متفق على أن…»'), BiText('Card 2 — Client phone call: a client is unhappy with a bill. Your goal: calm them down, check the facts, and promise one clear next step. Useful phrases: “If I understood you correctly…”, “Could you give me an example?”, “Let me think about that for a second.”', 'البطاقة 2 — مكالمة مع عميل: عميل غير راضٍ عن فاتورة. هدفك: تهدئته، والتحقق من الحقائق، والوعد بخطوة تالية واحدة واضحة. عبارات مفيدة: «إذا فهمتك بصورة صحيحة…»، «هل تستطيع أن تعطيني مثالاً؟»، «دعني أفكر في ذلك لثانية»'), BiText('Card 3 — A polite complaint: your hotel room is noisy and the air conditioning is broken. Your goal: complain firmly but politely and get a different room tonight. Useful phrases: “I take your point, but…”, “I see it slightly differently.”, “I’d go along with that, as long as…”', 'البطاقة 3 — شكوى مهذبة: غرفتك في الفندق صاخبة والمكيّف معطّل. هدفك: اشتِك بحزم وأدب واحصل على غرفة مختلفة الليلة. عبارات مفيدة: «أفهم وجهة نظرك، لكن…»، «أرى الأمر بصورة مختلفة قليلاً»، «أوافق على ذلك، بشرط أن…»')],
      ),
      LessonExercise(
        id: 'comm-followup', title: BiText('The follow-up question drill', 'تدريب أسئلة المتابعة'), minutes: 8,
        instructions: BiText('For each statement, reply with ONE follow-up question before you say anything about yourself — then keep the conversation going for two more exchanges. Good follow-ups start with What, How, Why, or “Tell me more about…”', 'لكل عبارة، أجب بسؤال متابعة واحد قبل أن تقول أي شيء عن نفسك — ثم واصل المحادثة لتبادلين إضافيين. أسئلة المتابعة الجيدة تبدأ بـ: ماذا، كيف، لماذا، أو «حدثني أكثر عن…»'),
        prompts: [BiText('“I’ve just moved to a new city for work.”', '«انتقلت للتو إلى مدينة جديدة من أجل العمل.»'), BiText('“We’re thinking of opening a small café.”', '«نفكر في افتتاح مقهى صغير.»'), BiText('“I failed my driving test for the third time.”', '«رسبت في اختبار القيادة للمرة الثالثة.»'), BiText('“My brother has started running marathons.”', '«بدأ أخي يركض في سباقات الماراثون.»'), BiText('“The course turned out to be much harder than I expected.”', '«تبيّن أن الدورة أصعب بكثير مما توقعت.»')],
      ),
    ],
  ),
];
