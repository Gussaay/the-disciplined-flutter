// The gym catalogue, ported from the React edition's equipment.js and
// exerciseGuide.js: every tool and exercise, the muscle regions each
// exercise trains, machine set-up steps and descriptions. Generated
// from the React sources so the two editions cannot drift apart.

class GymExercise {
  const GymExercise({required this.id, required this.en, required this.ar, required this.muscle, required this.howEn, required this.howAr, required this.unit});
  final String id;
  final String en;
  final String ar;
  final String muscle;
  final String howEn;
  final String howAr;
  final String unit;
}

class GymTool {
  const GymTool({required this.id, required this.icon, required this.en, required this.ar, required this.exercises});
  final String id;
  final String icon;
  final String en;
  final String ar;
  final List<GymExercise> exercises;
}

const Map<String, List<String>> kMuscles = {
  'chest': ['Chest', 'الصدر'],
  'back': ['Back', 'الظهر'],
  'shoulders': ['Shoulders', 'الأكتاف'],
  'biceps': ['Biceps', 'العضلة ذات الرأسين'],
  'triceps': ['Triceps', 'العضلة ثلاثية الرؤوس'],
  'legs': ['Legs', 'الأرجل'],
  'glutes': ['Glutes', 'الأرداف'],
  'core': ['Core', 'عضلات البطن'],
  'cardio': ['Cardio', 'اللياقة القلبية'],
};

const List<GymTool> kTools = [
  GymTool(id: 'treadmill', icon: '🏃', en: 'Treadmill', ar: 'جهاز المشي', exercises: [
    GymExercise(id: 'treadmill_walk', en: 'Incline walk', ar: 'مشي بميل', muscle: 'cardio', howEn: 'Walk at a brisk pace on a 5-10% incline. Stand tall and do not hold the rails.', howAr: 'امشِ بسرعة نشطة على ميل 5-10٪. قف منتصباً ولا تمسك المقابض.', unit: 'cardio'),
    GymExercise(id: 'treadmill_run', en: 'Run', ar: 'جري', muscle: 'cardio', howEn: 'Run at a pace where you can still say a short sentence. Land softly under your hips.', howAr: 'اجرِ بسرعة تستطيع معها قول جملة قصيرة. انزل بقدمك برفق تحت الورك.', unit: 'cardio'),
    GymExercise(id: 'treadmill_intervals', en: 'Intervals', ar: 'تمرين متقطع', muscle: 'cardio', howEn: '1 minute fast, 2 minutes easy. Repeat 6-8 times.', howAr: 'دقيقة سريعة ثم دقيقتان خفيفتان. كرر 6-8 مرات.', unit: 'cardio'),
  ]),
  GymTool(id: 'bike', icon: '🚴', en: 'Stationary bike', ar: 'الدراجة الثابتة', exercises: [
    GymExercise(id: 'bike_steady', en: 'Steady ride', ar: 'ركوب ثابت', muscle: 'cardio', howEn: 'Set the seat at hip height. Keep a steady effort you could hold for 30 minutes.', howAr: 'اضبط المقعد عند مستوى الورك. حافظ على مجهود ثابت تستطيع تحمله 30 دقيقة.', unit: 'cardio'),
    GymExercise(id: 'bike_intervals', en: 'Bike intervals', ar: 'دراجة متقطعة', muscle: 'cardio', howEn: '30 seconds hard, 90 seconds easy. Repeat 8 times.', howAr: '30 ثانية بقوة ثم 90 ثانية خفيفة. كرر 8 مرات.', unit: 'cardio'),
  ]),
  GymTool(id: 'elliptical', icon: '⛷️', en: 'Elliptical', ar: 'الإليبتيكال', exercises: [
    GymExercise(id: 'elliptical', en: 'Elliptical', ar: 'إليبتيكال', muscle: 'cardio', howEn: 'Push and pull the handles, keep your heels down and your chest up.', howAr: 'ادفع واسحب المقابض، أبقِ كعبيك على الدواسة وصدرك مرفوعاً.', unit: 'cardio'),
  ]),
  GymTool(id: 'rower', icon: '🚣', en: 'Rowing machine', ar: 'جهاز التجديف', exercises: [
    GymExercise(id: 'row_erg', en: 'Rowing', ar: 'تجديف', muscle: 'cardio', howEn: 'Legs first, then lean back, then pull the handle to the lower ribs. Return in the reverse order.', howAr: 'ادفع بالرجلين أولاً، ثم مِل للخلف، ثم اسحب المقبض إلى أسفل الأضلاع. ارجع بالترتيب العكسي.', unit: 'cardio'),
  ]),
  GymTool(id: 'stairs', icon: '🪜', en: 'Stair climber', ar: 'جهاز السلالم', exercises: [
    GymExercise(id: 'stairs', en: 'Stair climb', ar: 'صعود السلالم', muscle: 'cardio', howEn: 'Step with the whole foot, stay upright and rest your hands lightly on the rails.', howAr: 'اصعد بكامل القدم، ابقَ منتصباً وضع يديك برفق على المقابض.', unit: 'cardio'),
  ]),
  GymTool(id: 'bench', icon: '🏋️', en: 'Bench and barbell', ar: 'البنش والبار', exercises: [
    GymExercise(id: 'bench_press', en: 'Bench press', ar: 'ضغط الصدر بالبار', muscle: 'chest', howEn: 'Feet flat, shoulder blades squeezed. Lower the bar to mid-chest, then press up without bouncing.', howAr: 'ثبّت قدميك وضمّ لوحي الكتف. أنزل البار إلى منتصف الصدر ثم ادفعه دون ارتداد.', unit: 'kg'),
    GymExercise(id: 'incline_bench', en: 'Incline bench press', ar: 'ضغط صدر مائل', muscle: 'chest', howEn: 'Bench at 30-45°. Lower the bar to the upper chest and press straight up.', howAr: 'اضبط البنش على 30-45°. أنزل البار إلى أعلى الصدر وادفعه للأعلى.', unit: 'kg'),
    GymExercise(id: 'skull_crusher', en: 'Skull crusher', ar: 'تمديد الترايسبس مستلقياً', muscle: 'triceps', howEn: 'Upper arms still and vertical. Bend the elbows to bring the bar to the forehead, then extend.', howAr: 'ثبّت العضدين عمودياً. اثنِ المرفقين لإنزال البار نحو الجبهة ثم مدّهما.', unit: 'kg'),
  ]),
  GymTool(id: 'rack', icon: '🏗️', en: 'Squat rack', ar: 'قفص السكوات', exercises: [
    GymExercise(id: 'squat', en: 'Back squat', ar: 'سكوات بالبار', muscle: 'legs', howEn: 'Bar on the upper back, feet shoulder-width. Sit down and back until thighs are parallel, knees over toes, then drive up.', howAr: 'البار على أعلى الظهر والقدمان بعرض الكتفين. انزل حتى يوازي الفخذان الأرض والركبتان فوق الأصابع ثم ادفع للأعلى.', unit: 'kg'),
    GymExercise(id: 'deadlift', en: 'Deadlift', ar: 'الرفعة الميتة', muscle: 'back', howEn: 'Bar over mid-foot, flat back. Push the floor away and stand tall; lower with control.', howAr: 'البار فوق منتصف القدم والظهر مستقيم. ادفع الأرض وقف منتصباً ثم أنزل بتحكم.', unit: 'kg'),
    GymExercise(id: 'ohp', en: 'Overhead press', ar: 'ضغط الأكتاف واقفاً', muscle: 'shoulders', howEn: 'Bar at the collarbone, squeeze the glutes. Press straight overhead and bring the head through.', howAr: 'البار عند الترقوة مع شدّ الأرداف. ادفع البار فوق الرأس مباشرة.', unit: 'kg'),
    GymExercise(id: 'barbell_row', en: 'Barbell row', ar: 'تجديف بالبار', muscle: 'back', howEn: 'Hinge forward with a flat back. Pull the bar to the lower ribs and lower slowly.', howAr: 'انحنِ للأمام بظهر مستقيم. اسحب البار إلى أسفل الأضلاع وأنزله ببطء.', unit: 'kg'),
    GymExercise(id: 'hip_thrust', en: 'Hip thrust', ar: 'رفع الحوض', muscle: 'glutes', howEn: 'Upper back on a bench, bar over the hips. Drive the hips up until the body is level and squeeze.', howAr: 'أعلى الظهر على البنش والبار فوق الحوض. ارفع الحوض حتى يستوي الجسم واضغط.', unit: 'kg'),
  ]),
  GymTool(id: 'dumbbells', icon: '🏋️‍♂️', en: 'Dumbbells', ar: 'الدمبلز', exercises: [
    GymExercise(id: 'db_press', en: 'Dumbbell press', ar: 'ضغط صدر بالدمبل', muscle: 'chest', howEn: 'Lie on a bench, press both dumbbells up over the chest and lower until the elbows pass the bench line.', howAr: 'استلقِ على البنش وادفع الدمبلين فوق الصدر ثم أنزلهما حتى يتجاوز المرفقان مستوى البنش.', unit: 'kg'),
    GymExercise(id: 'db_row', en: 'One-arm row', ar: 'تجديف بذراع واحدة', muscle: 'back', howEn: 'One hand and knee on the bench. Pull the dumbbell to the hip, elbow close to the body.', howAr: 'ضع يداً وركبة على البنش. اسحب الدمبل نحو الورك والمرفق قريب من الجسم.', unit: 'kg'),
    GymExercise(id: 'db_shoulder', en: 'Shoulder press', ar: 'ضغط أكتاف بالدمبل', muscle: 'shoulders', howEn: 'Seated, dumbbells at ear height. Press up until the arms are straight, lower with control.', howAr: 'اجلس والدمبلان عند مستوى الأذن. ادفعهما حتى تستقيم الذراعان ثم أنزل بتحكم.', unit: 'kg'),
    GymExercise(id: 'lateral_raise', en: 'Lateral raise', ar: 'رفع جانبي', muscle: 'shoulders', howEn: 'Slight bend in the elbows. Raise the arms out to shoulder height, lower slowly.', howAr: 'اثنِ المرفقين قليلاً. ارفع الذراعين جانباً حتى مستوى الكتف وأنزل ببطء.', unit: 'kg'),
    GymExercise(id: 'db_curl', en: 'Biceps curl', ar: 'تمرين البايسبس', muscle: 'biceps', howEn: 'Elbows pinned to the sides. Curl up, squeeze, and lower all the way.', howAr: 'ثبّت المرفقين بجانب الجسم. ارفع الدمبل، اضغط، ثم أنزل كاملاً.', unit: 'kg'),
    GymExercise(id: 'hammer_curl', en: 'Hammer curl', ar: 'بايسبس مطرقة', muscle: 'biceps', howEn: 'Palms facing each other. Curl without swinging the body.', howAr: 'راحتا اليدين متقابلتان. ارفع دون تأرجح الجسم.', unit: 'kg'),
    GymExercise(id: 'db_triceps', en: 'Overhead triceps extension', ar: 'ترايسبس خلف الرأس', muscle: 'triceps', howEn: 'Hold one dumbbell overhead with both hands. Lower it behind the head and extend.', howAr: 'أمسك دمبلاً فوق الرأس بكلتا اليدين. أنزله خلف الرأس ثم مدّ الذراعين.', unit: 'kg'),
    GymExercise(id: 'goblet_squat', en: 'Goblet squat', ar: 'سكوات الكأس', muscle: 'legs', howEn: 'Hold a dumbbell at the chest. Squat between the knees, chest up.', howAr: 'أمسك دمبلاً عند الصدر. انزل بين الركبتين والصدر مرفوع.', unit: 'kg'),
    GymExercise(id: 'lunge', en: 'Lunge', ar: 'الطعن', muscle: 'legs', howEn: 'Step forward and lower until both knees are at 90°. Push back through the front heel.', howAr: 'اخطُ للأمام وانزل حتى تصبح الركبتان بزاوية 90°. ادفع بكعب القدم الأمامية للعودة.', unit: 'kg'),
    GymExercise(id: 'rdl', en: 'Romanian deadlift', ar: 'الرفعة الرومانية', muscle: 'glutes', howEn: 'Soft knees, push the hips back and slide the weights down the thighs until the hamstrings stretch.', howAr: 'اثنِ الركبتين قليلاً وادفع الحوض للخلف مع إنزال الوزن على الفخذين حتى تشعر بشد خلفي.', unit: 'kg'),
  ]),
  GymTool(id: 'kettlebell', icon: '🔔', en: 'Kettlebell', ar: 'الكيتل بل', exercises: [
    GymExercise(id: 'kb_swing', en: 'Kettlebell swing', ar: 'أرجحة الكيتل بل', muscle: 'glutes', howEn: 'Hinge at the hips and snap them forward to swing the bell to chest height. Arms stay loose.', howAr: 'انحنِ من الحوض ثم ادفعه للأمام بقوة لترجّح الوزن حتى مستوى الصدر. الذراعان مرتخيتان.', unit: 'kg'),
    GymExercise(id: 'kb_carry', en: 'Farmer carry', ar: 'مشي المزارع', muscle: 'core', howEn: 'Walk tall with a bell in each hand, shoulders back. Record the seconds.', howAr: 'امشِ منتصباً حاملاً وزناً في كل يد والكتفان للخلف. سجّل الثواني.', unit: 'time'),
  ]),
  GymTool(id: 'smith', icon: '🛤️', en: 'Smith machine', ar: 'جهاز سميث', exercises: [
    GymExercise(id: 'smith_squat', en: 'Smith squat', ar: 'سكوات سميث', muscle: 'legs', howEn: 'Feet slightly ahead of the bar. Lower until thighs are parallel and push up.', howAr: 'القدمان أمام البار قليلاً. انزل حتى يوازي الفخذان الأرض وادفع.', unit: 'kg'),
    GymExercise(id: 'smith_bench', en: 'Smith bench press', ar: 'ضغط صدر سميث', muscle: 'chest', howEn: 'Bench centred under the bar. Lower to mid-chest and press.', howAr: 'ضع البنش تحت البار في المنتصف. أنزل إلى منتصف الصدر وادفع.', unit: 'kg'),
  ]),
  GymTool(id: 'chest_press', icon: '💪', en: 'Chest press machine', ar: 'جهاز ضغط الصدر', exercises: [
    GymExercise(id: 'machine_chest_press', en: 'Machine chest press', ar: 'ضغط الصدر بالجهاز', muscle: 'chest', howEn: 'Handles at mid-chest height. Press forward without locking the elbows, return slowly.', howAr: 'اضبط المقابض عند منتصف الصدر. ادفع للأمام دون قفل المرفقين وارجع ببطء.', unit: 'kg'),
  ]),
  GymTool(id: 'pec_deck', icon: '🦋', en: 'Pec deck / fly machine', ar: 'جهاز الفراشة', exercises: [
    GymExercise(id: 'pec_fly', en: 'Machine fly', ar: 'تفتيح الصدر بالجهاز', muscle: 'chest', howEn: 'Slight bend in the elbows. Bring the handles together in front of the chest and open slowly.', howAr: 'اثنِ المرفقين قليلاً. ضمّ المقبضين أمام الصدر وافتح ببطء.', unit: 'kg'),
    GymExercise(id: 'rear_delt_fly', en: 'Reverse fly', ar: 'فراشة عكسية', muscle: 'shoulders', howEn: 'Face the pad. Pull the handles back in a wide arc, squeezing the shoulder blades.', howAr: 'واجه المسند. اسحب المقبضين للخلف في قوس واسع مع ضم لوحي الكتف.', unit: 'kg'),
  ]),
  GymTool(id: 'lat_pulldown', icon: '⬇️', en: 'Lat pulldown', ar: 'جهاز السحب العلوي', exercises: [
    GymExercise(id: 'lat_pulldown', en: 'Lat pulldown', ar: 'سحب علوي', muscle: 'back', howEn: 'Grip wider than the shoulders. Pull the bar to the upper chest, elbows down, then return fully.', howAr: 'أمسك البار أوسع من الكتفين. اسحبه إلى أعلى الصدر والمرفقان للأسفل ثم ارجع كاملاً.', unit: 'kg'),
    GymExercise(id: 'close_pulldown', en: 'Close-grip pulldown', ar: 'سحب علوي ضيق', muscle: 'back', howEn: 'Narrow handle, lean back a little and pull to the chest.', howAr: 'بمقبض ضيق، مِل للخلف قليلاً واسحب إلى الصدر.', unit: 'kg'),
  ]),
  GymTool(id: 'seated_row', icon: '↔️', en: 'Seated row', ar: 'جهاز التجديف جالساً', exercises: [
    GymExercise(id: 'seated_row', en: 'Seated row', ar: 'تجديف جالساً', muscle: 'back', howEn: 'Sit tall with the chest on the pad. Pull the handles to the stomach, squeeze the shoulder blades, return with straight arms.', howAr: 'اجلس منتصباً والصدر على المسند. اسحب المقابض إلى البطن وضمّ لوحي الكتف ثم ارجع بذراعين ممدودتين.', unit: 'kg'),
  ]),
  GymTool(id: 'tbar_row', icon: '🏋️', en: 'T-bar row', ar: 'جهاز التجديف T-bar', exercises: [
    GymExercise(id: 'tbar_row', en: 'T-bar row', ar: 'تجديف T-bar', muscle: 'back', howEn: 'Feet on the foot plates, knees soft. Hinge forward with a flat back. Pull the handles to the chest and squeeze the shoulder blades. Lower until the arms are straight.', howAr: 'ضع القدمين على مكان القدم والركبتان منثنيتان قليلاً. انحنِ للأمام بظهر مستقيم. اسحب المقابض إلى الصدر وضمّ لوحي الكتف. أنزل حتى تستقيم الذراعان.', unit: 'kg'),
  ]),
  GymTool(id: 'preacher_curl', icon: '💪', en: 'Preacher curl', ar: 'جهاز البايسبس (بريتشر)', exercises: [
    GymExercise(id: 'preacher_curl', en: 'Preacher curl', ar: 'بايسبس بريتشر', muscle: 'biceps', howEn: 'Armpits on the top of the pad, the backs of the arms flat on it. Curl the handle up towards the shoulders and squeeze. Lower slowly until the arms are almost straight.', howAr: 'الإبطان على أعلى المسند وخلف الذراعين ملاصق له. ارفع المقبض نحو الكتفين واضغط. أنزل ببطء حتى تكاد الذراعان تستقيمان.', unit: 'kg'),
  ]),
  GymTool(id: 'assisted_chin_dip', icon: '🧗', en: 'Assisted chin / dip', ar: 'جهاز العقلة والمتوازي المساعد', exercises: [
    GymExercise(id: 'assisted_pullup', en: 'Assisted pull-up', ar: 'عقلة بمساعدة', muscle: 'back', howEn: 'Kneel on the pad and hold the top handles wide. Pull until the chin passes the handles. Lower all the way with control.', howAr: 'اركع على المسند وأمسك المقابض العلوية بعرض. اسحب حتى يتجاوز الذقن المقابض. انزل كاملاً بتحكم.', unit: 'kg'),
    GymExercise(id: 'assisted_chinup', en: 'Assisted chin-up', ar: 'عقلة مساعدة بقبضة معكوسة', muscle: 'biceps', howEn: 'Kneel on the pad, palms facing you on the narrow handles. Pull the chest up to the hands. Lower all the way.', howAr: 'اركع على المسند وراحتا اليدين نحوك على المقابض الضيقة. اسحب الصدر نحو اليدين. انزل كاملاً.', unit: 'kg'),
    GymExercise(id: 'assisted_dip', en: 'Assisted dip', ar: 'متوازي بمساعدة', muscle: 'triceps', howEn: 'Kneel on the pad and hold the dip handles with straight arms. Lower until the elbows are at 90°. Press back up without locking the elbows.', howAr: 'اركع على المسند وأمسك مقابض المتوازي بذراعين ممدودتين. انزل حتى يصبح المرفقان بزاوية 90°. ادفع للأعلى دون قفل المرفقين.', unit: 'kg'),
  ]),
  GymTool(id: 'cable', icon: '🔗', en: 'Cable column', ar: 'جهاز الكيبل', exercises: [
    GymExercise(id: 'triceps_pushdown', en: 'Triceps pushdown', ar: 'ترايسبس بالكيبل', muscle: 'triceps', howEn: 'Elbows at the sides. Push the bar down until the arms are straight, return to 90°.', howAr: 'ثبّت المرفقين بالجانبين. ادفع البار حتى تستقيم الذراعان ثم ارجع إلى 90°.', unit: 'kg'),
    GymExercise(id: 'cable_curl', en: 'Cable curl', ar: 'بايسبس بالكيبل', muscle: 'biceps', howEn: 'Low pulley. Curl the bar up with still elbows.', howAr: 'من البكرة السفلية، ارفع البار مع ثبات المرفقين.', unit: 'kg'),
    GymExercise(id: 'cable_fly', en: 'Cable crossover', ar: 'تفتيح بالكيبل', muscle: 'chest', howEn: 'High pulleys. Step forward and bring the hands together in front of the hips.', howAr: 'من البكرتين العلويتين، تقدم خطوة وضمّ اليدين أمام الحوض.', unit: 'kg'),
    GymExercise(id: 'face_pull', en: 'Face pull', ar: 'سحب للوجه', muscle: 'shoulders', howEn: 'Rope at face height. Pull towards the eyes with elbows high.', howAr: 'الحبل عند مستوى الوجه. اسحبه نحو العينين والمرفقان مرفوعان.', unit: 'kg'),
    GymExercise(id: 'cable_crunch', en: 'Cable crunch', ar: 'طحن البطن بالكيبل', muscle: 'core', howEn: 'Kneel under the pulley, rope beside the head. Curl the ribs towards the hips.', howAr: 'اجثُ تحت البكرة والحبل بجانب الرأس. اثنِ الأضلاع نحو الحوض.', unit: 'kg'),
  ]),
  GymTool(id: 'shoulder_press', icon: '🙆', en: 'Shoulder press machine', ar: 'جهاز ضغط الأكتاف', exercises: [
    GymExercise(id: 'machine_shoulder_press', en: 'Machine shoulder press', ar: 'ضغط الأكتاف بالجهاز', muscle: 'shoulders', howEn: 'Handles at shoulder height. Press up without arching the back.', howAr: 'المقابض عند مستوى الكتف. ادفع للأعلى دون تقويس الظهر.', unit: 'kg'),
  ]),
  GymTool(id: 'leg_press', icon: '🦵', en: 'Leg press', ar: 'جهاز ضغط الأرجل', exercises: [
    GymExercise(id: 'leg_press', en: 'Leg press', ar: 'ضغط الأرجل', muscle: 'legs', howEn: 'Feet shoulder-width on the plate. Lower until the knees are at 90° and push without locking them.', howAr: 'القدمان بعرض الكتفين على اللوح. انزل حتى زاوية 90° وادفع دون قفل الركبتين.', unit: 'kg'),
    GymExercise(id: 'calf_press', en: 'Calf press', ar: 'ضغط السمانة', muscle: 'legs', howEn: 'Balls of the feet on the edge of the plate. Push with the ankles only.', howAr: 'ضع مقدمة القدم على حافة اللوح. ادفع بالكاحلين فقط.', unit: 'kg'),
  ]),
  GymTool(id: 'leg_extension', icon: '🦿', en: 'Leg extension', ar: 'جهاز تمديد الأرجل', exercises: [
    GymExercise(id: 'leg_extension', en: 'Leg extension', ar: 'تمديد الأرجل', muscle: 'legs', howEn: 'Pad on the lower shin. Straighten the knees, pause, lower slowly.', howAr: 'المسند على أسفل الساق. مدّ الركبتين، توقف لحظة، ثم أنزل ببطء.', unit: 'kg'),
  ]),
  GymTool(id: 'leg_curl', icon: '🦵', en: 'Leg curl', ar: 'جهاز ثني الأرجل', exercises: [
    GymExercise(id: 'leg_curl', en: 'Leg curl', ar: 'ثني الأرجل', muscle: 'legs', howEn: 'Lie face down, knees just past the bench, pad above the heels. Curl the heels towards the glutes, keeping the hips down. Return with control.', howAr: 'استلقِ على بطنك والركبتان بعد حافة المقعد والمسند فوق الكعبين. اثنِ الكعبين نحو الأرداف مع إبقاء الحوض ملاصقاً. ارجع بتحكم.', unit: 'kg'),
  ]),
  GymTool(id: 'calf_raise', icon: '🦶', en: 'Seated calf raise machine', ar: 'جهاز رفع السمانة جالساً', exercises: [
    GymExercise(id: 'seated_calf_raise', en: 'Seated calf raise', ar: 'رفع السمانة جالساً', muscle: 'legs', howEn: 'Balls of the feet on the platform edge, pads resting on the thighs. Lower the heels below the platform for a full stretch, then press up onto the toes as high as you can. Pause at the top.', howAr: 'ضع مقدمة القدمين على حافة المنصة والمسندين على الفخذين. أنزل الكعبين أسفل المنصة لتمدّد كامل ثم ادفع بأصابع القدمين إلى أعلى ما يمكن. توقف لحظة في الأعلى.', unit: 'kg'),
  ]),
  GymTool(id: 'hip_machine', icon: '🍑', en: 'Hip abductor / adductor', ar: 'جهاز فتح وضم الفخذين', exercises: [
    GymExercise(id: 'hip_abduction', en: 'Hip abduction', ar: 'فتح الفخذين', muscle: 'glutes', howEn: 'Push the knees out against the pads, pause, return slowly.', howAr: 'ادفع الركبتين للخارج ضد المسندين، توقف، وارجع ببطء.', unit: 'kg'),
    GymExercise(id: 'hip_adduction', en: 'Hip adduction', ar: 'ضم الفخذين', muscle: 'legs', howEn: 'Squeeze the knees together against the pads, return slowly.', howAr: 'ضمّ الركبتين ضد المسندين وارجع ببطء.', unit: 'kg'),
  ]),
  GymTool(id: 'pullup_bar', icon: '🧗', en: 'Pull-up / dip station', ar: 'العقلة والمتوازي', exercises: [
    GymExercise(id: 'pullup', en: 'Pull-up', ar: 'العقلة', muscle: 'back', howEn: 'Hang with straight arms. Pull until the chin passes the bar, lower all the way.', howAr: 'تعلّق بذراعين ممدودتين. اسحب حتى يتجاوز الذقن البار ثم انزل كاملاً.', unit: 'bw'),
    GymExercise(id: 'chinup', en: 'Chin-up', ar: 'عقلة بقبضة معكوسة', muscle: 'biceps', howEn: 'Palms facing you, shoulder-width. Pull the chest to the bar.', howAr: 'راحتا اليدين نحوك بعرض الكتفين. اسحب الصدر نحو البار.', unit: 'bw'),
    GymExercise(id: 'dip', en: 'Dip', ar: 'المتوازي', muscle: 'triceps', howEn: 'Lower until the shoulders are just below the elbows, press back up.', howAr: 'انزل حتى يصبح الكتفان أسفل المرفقين قليلاً ثم ادفع للأعلى.', unit: 'bw'),
    GymExercise(id: 'hanging_leg_raise', en: 'Hanging leg raise', ar: 'رفع الأرجل معلّقاً', muscle: 'core', howEn: 'Hang from the bar and raise the legs to hip height without swinging.', howAr: 'تعلّق بالبار وارفع الرجلين إلى مستوى الحوض دون تأرجح.', unit: 'bw'),
  ]),
  GymTool(id: 'bodyweight', icon: '🤸', en: 'Body weight / mat', ar: 'وزن الجسم والبساط', exercises: [
    GymExercise(id: 'pushup', en: 'Push-up', ar: 'الضغط', muscle: 'chest', howEn: 'Body in one line. Lower the chest to the floor, elbows at 45°, push up.', howAr: 'الجسم في خط واحد. أنزل الصدر إلى الأرض والمرفقان بزاوية 45° ثم ادفع.', unit: 'bw'),
    GymExercise(id: 'plank', en: 'Plank', ar: 'البلانك', muscle: 'core', howEn: 'Elbows under shoulders, body straight, glutes tight. Record the seconds.', howAr: 'المرفقان تحت الكتفين والجسم مستقيم مع شد الأرداف. سجّل الثواني.', unit: 'time'),
    GymExercise(id: 'crunch', en: 'Crunch', ar: 'تمرين البطن', muscle: 'core', howEn: 'Lower back on the floor. Lift the shoulder blades and lower slowly.', howAr: 'أسفل الظهر على الأرض. ارفع لوحي الكتف وأنزل ببطء.', unit: 'bw'),
    GymExercise(id: 'bw_squat', en: 'Body-weight squat', ar: 'سكوات بوزن الجسم', muscle: 'legs', howEn: 'Arms forward, sit back and down, stand up fully.', howAr: 'مدّ الذراعين للأمام، انزل للخلف والأسفل، ثم قف كاملاً.', unit: 'bw'),
    GymExercise(id: 'burpee', en: 'Burpee', ar: 'بيربي', muscle: 'cardio', howEn: 'Squat, jump the feet back, push-up, jump the feet in and jump up.', howAr: 'انزل قرفصاء، اقفز بالقدمين للخلف، اضغط، اقفز بالقدمين للأمام ثم اقفز للأعلى.', unit: 'bw'),
  ]),
  GymTool(id: 'bands', icon: '🎗️', en: 'Resistance bands', ar: 'أحزمة المقاومة', exercises: [
    GymExercise(id: 'band_pull_apart', en: 'Band pull-apart', ar: 'شد الحزام', muscle: 'shoulders', howEn: 'Arms straight in front. Pull the band apart to the chest.', howAr: 'مدّ الذراعين أمامك. شدّ الحزام حتى يلامس الصدر.', unit: 'bw'),
    GymExercise(id: 'band_row', en: 'Band row', ar: 'تجديف بالحزام', muscle: 'back', howEn: 'Anchor the band, pull the hands to the ribs.', howAr: 'ثبّت الحزام واسحب اليدين إلى الأضلاع.', unit: 'bw'),
  ]),
];

const Map<String, List<String>> kRegions = {
  'chest': ['Chest (pectoralis major)', 'الصدر (العضلة الصدرية الكبرى)'],
  'front_delt': ['Front of the shoulder', 'مقدمة الكتف'],
  'side_delt': ['Side of the shoulder', 'جانب الكتف'],
  'rear_delt': ['Back of the shoulder', 'خلفية الكتف'],
  'biceps': ['Biceps', 'العضلة ذات الرأسين (البايسبس)'],
  'triceps': ['Triceps', 'العضلة ثلاثية الرؤوس (الترايسبس)'],
  'forearms': ['Forearms and grip', 'الساعد والقبضة'],
  'abs': ['Abs (rectus abdominis)', 'عضلات البطن المستقيمة'],
  'obliques': ['Obliques (sides of the waist)', 'الخواصر (العضلات المائلة)'],
  'lats': ['Lats (latissimus dorsi)', 'الظهر العريضة (المجنص)'],
  'traps': ['Traps (trapezius)', 'شبه المنحرفة (الترابيس)'],
  'mid_back': ['Middle back (rhomboids)', 'وسط الظهر (المعينية)'],
  'lower_back': ['Lower back (spinal erectors)', 'أسفل الظهر (ناصبات الفقار)'],
  'glutes': ['Glutes', 'الأرداف (الألوية)'],
  'quads': ['Front of the thigh (quadriceps)', 'الفخذ الأمامية (الرباعية)'],
  'hamstrings': ['Back of the thigh (hamstrings)', 'الفخذ الخلفية'],
  'adductors': ['Inner thigh (adductors)', 'الفخذ الداخلية (المقربة)'],
  'abductors': ['Outer hip (abductors)', 'الورك الخارجي (المبعدة)'],
  'calves': ['Calves', 'السمانة (بطة الساق)'],
  'heart': ['Heart and lungs', 'القلب والرئتان'],
};

class ExerciseTargets {
  const ExerciseTargets(this.primary, this.secondary, this.motion);
  final List<String> primary;
  final List<String> secondary;
  final String? motion;
}

const Map<String, ExerciseTargets> kTargets = {
  'treadmill_walk': ExerciseTargets(['heart', 'quads', 'glutes'], ['calves', 'hamstrings'], 'walk'),
  'treadmill_run': ExerciseTargets(['heart', 'quads', 'glutes'], ['calves', 'hamstrings'], 'run'),
  'treadmill_intervals': ExerciseTargets(['heart', 'quads', 'glutes'], ['calves', 'hamstrings'], 'run'),
  'bike_steady': ExerciseTargets(['heart', 'quads'], ['glutes', 'calves', 'hamstrings'], 'bike'),
  'bike_intervals': ExerciseTargets(['heart', 'quads'], ['glutes', 'calves', 'hamstrings'], 'bike'),
  'elliptical': ExerciseTargets(['heart', 'quads', 'glutes'], ['hamstrings', 'chest', 'lats'], 'walk'),
  'row_erg': ExerciseTargets(['heart', 'lats', 'mid_back', 'quads'], ['biceps', 'glutes', 'hamstrings'], 'rowErg'),
  'stairs': ExerciseTargets(['heart', 'glutes', 'quads'], ['calves', 'hamstrings'], 'walk'),
  'bench_press': ExerciseTargets(['chest'], ['front_delt', 'triceps'], 'benchPress'),
  'incline_bench': ExerciseTargets(['chest', 'front_delt'], ['triceps'], 'benchPress'),
  'skull_crusher': ExerciseTargets(['triceps'], [], 'skull'),
  'squat': ExerciseTargets(['quads', 'glutes'], ['hamstrings', 'lower_back', 'abs', 'adductors'], 'squat'),
  'deadlift': ExerciseTargets(['glutes', 'hamstrings', 'lower_back'], ['quads', 'traps', 'forearms', 'lats'], 'hinge'),
  'ohp': ExerciseTargets(['front_delt', 'side_delt', 'triceps'], ['traps', 'abs'], 'pressUp'),
  'barbell_row': ExerciseTargets(['lats', 'mid_back'], ['rear_delt', 'biceps', 'lower_back'], 'bentRow'),
  'hip_thrust': ExerciseTargets(['glutes'], ['hamstrings', 'quads'], 'hipThrust'),
  'db_press': ExerciseTargets(['chest'], ['front_delt', 'triceps'], 'benchPress'),
  'db_row': ExerciseTargets(['lats', 'mid_back'], ['rear_delt', 'biceps'], 'bentRow'),
  'db_shoulder': ExerciseTargets(['front_delt', 'side_delt'], ['triceps', 'traps'], 'pressUp'),
  'lateral_raise': ExerciseTargets(['side_delt'], ['traps', 'front_delt'], 'lateral'),
  'db_curl': ExerciseTargets(['biceps'], ['forearms'], 'curl'),
  'hammer_curl': ExerciseTargets(['biceps', 'forearms'], [], 'curl'),
  'db_triceps': ExerciseTargets(['triceps'], [], 'overheadExt'),
  'goblet_squat': ExerciseTargets(['quads', 'glutes'], ['adductors', 'abs'], 'squat'),
  'lunge': ExerciseTargets(['quads', 'glutes'], ['hamstrings', 'adductors', 'calves'], 'lunge'),
  'rdl': ExerciseTargets(['hamstrings', 'glutes'], ['lower_back', 'forearms'], 'hinge'),
  'kb_swing': ExerciseTargets(['glutes', 'hamstrings'], ['lower_back', 'abs', 'front_delt'], 'hinge'),
  'kb_carry': ExerciseTargets(['forearms', 'traps', 'abs'], ['obliques', 'glutes'], 'walk'),
  'smith_squat': ExerciseTargets(['quads', 'glutes'], ['hamstrings'], 'squat'),
  'smith_bench': ExerciseTargets(['chest'], ['front_delt', 'triceps'], 'benchPress'),
  'machine_chest_press': ExerciseTargets(['chest'], ['front_delt', 'triceps'], 'chestPress'),
  'pec_fly': ExerciseTargets(['chest'], ['front_delt'], 'fly'),
  'rear_delt_fly': ExerciseTargets(['rear_delt', 'mid_back'], ['traps'], 'reverseFly'),
  'lat_pulldown': ExerciseTargets(['lats'], ['biceps', 'mid_back', 'rear_delt'], 'pulldown'),
  'close_pulldown': ExerciseTargets(['lats'], ['biceps', 'mid_back'], 'pulldown'),
  'seated_row': ExerciseTargets(['mid_back', 'lats'], ['rear_delt', 'biceps', 'traps'], 'seatedRow'),
  'tbar_row': ExerciseTargets(['lats', 'mid_back'], ['rear_delt', 'biceps', 'traps', 'lower_back'], 'tbarRow'),
  'preacher_curl': ExerciseTargets(['biceps'], ['forearms'], 'preacher'),
  'assisted_pullup': ExerciseTargets(['lats'], ['biceps', 'mid_back', 'rear_delt'], 'pullup'),
  'assisted_chinup': ExerciseTargets(['lats', 'biceps'], ['mid_back', 'forearms'], 'pullup'),
  'assisted_dip': ExerciseTargets(['triceps', 'chest'], ['front_delt'], 'dip'),
  'triceps_pushdown': ExerciseTargets(['triceps'], [], 'pushdown'),
  'cable_curl': ExerciseTargets(['biceps'], ['forearms'], 'curl'),
  'cable_fly': ExerciseTargets(['chest'], ['front_delt'], 'fly'),
  'face_pull': ExerciseTargets(['rear_delt', 'mid_back'], ['traps', 'side_delt'], 'seatedRow'),
  'cable_crunch': ExerciseTargets(['abs'], ['obliques'], 'crunch'),
  'machine_shoulder_press': ExerciseTargets(['front_delt', 'side_delt'], ['triceps'], 'pressUp'),
  'leg_press': ExerciseTargets(['quads', 'glutes'], ['hamstrings', 'adductors'], 'legPress'),
  'calf_press': ExerciseTargets(['calves'], [], 'calf'),
  'leg_extension': ExerciseTargets(['quads'], [], 'legExt'),
  'leg_curl': ExerciseTargets(['hamstrings'], ['calves'], 'legCurl'),
  'seated_calf_raise': ExerciseTargets(['calves'], [], 'calf'),
  'hip_abduction': ExerciseTargets(['abductors', 'glutes'], [], 'abduction'),
  'hip_adduction': ExerciseTargets(['adductors'], [], 'abduction'),
  'pullup': ExerciseTargets(['lats'], ['biceps', 'mid_back', 'rear_delt', 'forearms'], 'pullup'),
  'chinup': ExerciseTargets(['lats', 'biceps'], ['mid_back', 'forearms'], 'pullup'),
  'dip': ExerciseTargets(['triceps', 'chest'], ['front_delt'], 'dip'),
  'hanging_leg_raise': ExerciseTargets(['abs'], ['obliques', 'forearms'], 'legRaise'),
  'pushup': ExerciseTargets(['chest'], ['triceps', 'front_delt', 'abs'], 'pushup'),
  'plank': ExerciseTargets(['abs'], ['obliques', 'glutes', 'front_delt'], 'plank'),
  'crunch': ExerciseTargets(['abs'], ['obliques'], 'crunch'),
  'bw_squat': ExerciseTargets(['quads', 'glutes'], ['hamstrings'], 'squat'),
  'burpee': ExerciseTargets(['heart', 'quads', 'chest'], ['glutes', 'triceps', 'abs'], 'squat'),
  'band_pull_apart': ExerciseTargets(['rear_delt', 'mid_back'], ['traps'], 'reverseFly'),
  'band_row': ExerciseTargets(['mid_back', 'lats'], ['biceps', 'rear_delt'], 'seatedRow'),
};

const Map<String, List<String>> kToolDesc = {
  'lat_pulldown': ['A cable machine with a wide bar above a seat and a pad that locks your thighs down. You pull the bar down to your upper chest, training the lats — the big wing muscles of the back — with the biceps and middle back helping. It builds towards a full pull-up.', 'جهاز كيبل فيه بار عريض فوق مقعد ومسند يثبّت فخذيك. تسحب البار إلى أعلى صدرك فتدرّب عضلات الظهر العريضة (المجنص) ويساعدها البايسبس ووسط الظهر. وهو خطوة نحو تمرين العقلة الكامل.'],
  'seated_row': ['A cable rowing machine: you sit tall, brace your feet, and pull the handles into your stomach. It trains the middle back and lats and teaches the shoulder blades to squeeze together — the rowing half of back training, next to the pulldown.', 'جهاز تجديف بالكيبل: تجلس منتصباً وتثبّت قدميك وتسحب المقبضين إلى بطنك. يدرّب وسط الظهر والعضلات العريضة ويعلّم لوحي الكتف الانضمام معاً — وهو نصف تدريب الظهر الأفقي بجانب السحب العلوي.'],
  'pec_deck': ['A seated fly machine with two swinging arms — the "butterfly". Facing forward it brings the arms together in front of the chest to train the chest; turn around and face the pad and the same machine trains the back of the shoulders with a reverse fly.', 'جهاز تفتيح جالس بذراعين متأرجحتين — «الفراشة». وأنت مواجه للأمام يضمّ الذراعين أمام الصدر لتدريب عضلات الصدر؛ واستدر وواجه المسند فيدرّب الجهاز نفسه خلفية الكتفين بحركة الفراشة العكسية.'],
  'chest_press': ['A seated pressing machine that guides the handles along a fixed path — the machine version of the bench press. It trains the chest, with the front of the shoulders and the triceps helping, and the fixed path makes it easy to push hard safely.', 'جهاز دفع جالس يوجّه المقبضين في مسار ثابت — وهو نسخة الجهاز من تمرين البنش برس. يدرّب الصدر ويساعده مقدمة الكتفين والترايسبس، والمسار الثابت يجعل الدفع بقوة أكثر أماناً.'],
  'tbar_row': ['A plate-loaded rowing machine: plates go on the loading bar and you row the handles towards your body. It trains the lats and the middle back with heavy loads, and the chest-supported versions rest your trunk on a pad so the lower back stays out of it.', 'جهاز تجديف يعمل بالأقراص: توضع الأقراص على عمود التحميل وتسحب المقبضين نحو جسمك. يدرّب العضلات العريضة ووسط الظهر بأوزان ثقيلة، وفي الأنواع ذات مسند الصدر يستريح جذعك على المسند فلا يتحمل أسفل الظهر العبء.'],
  'calf_raise': ['A plate-loaded machine for the calves: you sit with pads resting on your thighs and press the platform away with the balls of your feet. Sitting with bent knees puts the work on the soleus, the deep calf muscle, with the outer calf (gastrocnemius) helping.', 'جهاز للسمانة يعمل بالأقراص: تجلس والمسندان على فخذيك وتدفع المنصة بمقدمة قدميك. الجلوس مع ثني الركبتين يضع الجهد على عضلة النعلية العميقة في السمانة، وتساعدها العضلة الخارجية (ذات البطنين).'],
};

const Map<String, List<List<String>>> kToolSetup = {
  'chest_press': [['Adjust the seat so the handles are level with the middle of your chest (the handle under the seat).', 'اضبط المقعد حتى تكون المقابض بمستوى منتصف صدرك (المقبض أسفل المقعد).'], ['Back flat on the pad, feet flat on the floor.', 'الظهر ملاصق للمسند والقدمان على الأرض.']],
  'leg_extension': [['Move the back pad so your knees line up with the machine\'s pivot (the red dot).', 'حرّك مسند الظهر حتى تكون ركبتاك على محور الجهاز (النقطة الحمراء).'], ['Set the shin pad just above the ankles.', 'اضبط مسند الساق فوق الكاحلين مباشرة.']],
  'leg_curl': [['Lie face down with the knees just past the edge of the bench.', 'استلقِ على بطنك والركبتان بعد حافة المقعد مباشرة.'], ['Set the roller just above the heels and hold the handles.', 'اضبط الأسطوانة فوق الكعبين مباشرة وأمسك المقابض.']],
  'seated_row': [['Set the seat so the handles are level with your lower chest.', 'اضبط المقعد حتى تكون المقابض بمستوى أسفل صدرك.'], ['Set the chest pad so you reach the handles with straight arms.', 'اضبط مسند الصدر حتى تصل إلى المقابض بذراعين ممدودتين.']],
  'tbar_row': [['Load the same plates on the end of the bar and fit the clip.', 'ضع الأقراص على طرف البار وثبّتها بالمشبك.'], ['Stand on the foot plates over the bar and take the handles.', 'قف على مكان القدمين فوق البار وأمسك المقابض.']],
  'preacher_curl': [['Load the same plates on both sides.', 'ضع أقراصاً متساوية على الجانبين.'], ['Set the seat so your armpits sit on the top edge of the pad.', 'اضبط المقعد حتى يستقر الإبطان على الحافة العليا للمسند.']],
  'assisted_chin_dip': [['The weight helps you: more weight means easier, less weight means harder.', 'الوزن هنا يساعدك: وزن أكثر يعني أسهل، ووزن أقل يعني أصعب.'], ['Step up, take the handles, then lower the knee pad and kneel on it.', 'اصعد وأمسك المقابض ثم أنزل مسند الركبتين واركع عليه.']],
  'cable': [['Set the pulley height: pull the pin, slide the pulley, let the pin click in.', 'اضبط ارتفاع البكرة: اسحب المسمار، حرّك البكرة، ثم اتركه يثبت.'], ['Clip on the right handle (straight bar, rope or single handle).', 'ركّب المقبض المناسب (بار مستقيم أو حبل أو مقبض فردي).']],
  'lat_pulldown': [['Set the thigh pad so your legs are locked under it.', 'اضبط مسند الفخذين حتى تثبت رجلاك تحته.']],
  'leg_press': [['Feet shoulder-width in the middle of the plate, back flat on the pad.', 'القدمان بعرض الكتفين في منتصف اللوح والظهر ملاصق للمسند.'], ['Release the safety handles before you start and lock them when you finish.', 'افتح مقابض الأمان قبل البدء وأغلقها عند الانتهاء.']],
  'shoulder_press': [['Adjust the seat so the handles are at shoulder height.', 'اضبط المقعد حتى تكون المقابض بمستوى الكتفين.']],
  'pec_deck': [['Set the seat so the handles are level with the middle of your chest.', 'اضبط المقعد حتى تكون المقابض بمستوى منتصف صدرك.'], ['For the fly, sit facing out with your back on the pad; for the reverse fly, turn around and put your chest on the pad.', 'للتفتيح اجلس وظهرك على المسند مواجهاً للخارج؛ وللفراشة العكسية استدر وضع صدرك على المسند.']],
  'calf_raise': [['Load the same plates on both sides of the loading horn.', 'ضع أقراصاً متساوية على جانبي عمود التحميل.'], ['Sit with the balls of your feet on the platform edge and the pads resting on your thighs, just above the knees.', 'اجلس ومقدمة القدمين على حافة المنصة والمسندان على فخذيك فوق الركبتين مباشرة.'], ['Lift the weight a little and swing the safety stop away before the first set; swing it back when you finish.', 'ارفع الوزن قليلاً وأبعد ذراع الأمان قبل أول مجموعة وأعدها عند الانتهاء.']],
};

class ProgramDay {
  const ProgramDay(this.en, this.ar, this.exercises);
  final String en;
  final String ar;
  final List<String> exercises;
}

class GymProgram {
  const GymProgram(this.id, this.en, this.ar, this.aboutEn, this.aboutAr, this.days);
  final String id;
  final String en;
  final String ar;
  final String aboutEn;
  final String aboutAr;
  final List<ProgramDay> days;
}

const List<GymProgram> kPrograms = [
  GymProgram('full3', 'Full body · 3 days', 'الجسم كامل · 3 أيام', 'Best start for beginners: every muscle three times a week.', 'أفضل بداية للمبتدئين: كل عضلة ثلاث مرات أسبوعياً.', [ProgramDay('Day A', 'اليوم أ', ['leg_press', 'machine_chest_press', 'lat_pulldown', 'machine_shoulder_press', 'plank']), ProgramDay('Day B', 'اليوم ب', ['goblet_squat', 'db_press', 'seated_row', 'lateral_raise', 'crunch']), ProgramDay('Day C', 'اليوم ج', ['rdl', 'pushup', 'db_row', 'db_curl', 'triceps_pushdown'])]),
  GymProgram('ul4', 'Upper / lower · 4 days', 'علوي / سفلي · 4 أيام', 'Two upper-body and two lower-body days.', 'يومان للجزء العلوي ويومان للسفلي.', [ProgramDay('Upper 1', 'علوي 1', ['bench_press', 'lat_pulldown', 'db_shoulder', 'seated_row', 'triceps_pushdown', 'db_curl']), ProgramDay('Lower 1', 'سفلي 1', ['squat', 'leg_curl', 'leg_extension', 'calf_press', 'plank']), ProgramDay('Upper 2', 'علوي 2', ['incline_bench', 'db_row', 'lateral_raise', 'pec_fly', 'face_pull', 'hammer_curl']), ProgramDay('Lower 2', 'سفلي 2', ['deadlift', 'leg_press', 'lunge', 'hip_abduction', 'cable_crunch'])]),
  GymProgram('ppl', 'Push / pull / legs', 'دفع / سحب / أرجل', 'Three days, or repeat twice for six.', 'ثلاثة أيام، أو كررها مرتين لستة أيام.', [ProgramDay('Push', 'دفع', ['bench_press', 'db_shoulder', 'incline_bench', 'lateral_raise', 'triceps_pushdown', 'dip']), ProgramDay('Pull', 'سحب', ['lat_pulldown', 'barbell_row', 'seated_row', 'face_pull', 'db_curl', 'hammer_curl']), ProgramDay('Legs', 'أرجل', ['squat', 'rdl', 'leg_press', 'leg_curl', 'calf_press', 'hanging_leg_raise'])]),
  GymProgram('home', 'Home · no equipment', 'المنزل · بدون أجهزة', 'Body weight only, 25 minutes.', 'بوزن الجسم فقط، 25 دقيقة.', [ProgramDay('Circuit', 'دائرة', ['bw_squat', 'pushup', 'lunge', 'plank', 'crunch', 'burpee'])]),
];

GymExercise? exerciseById(String id) {
  for (final t in kTools) {
    for (final e in t.exercises) {
      if (e.id == id) return e;
    }
  }
  return null;
}

GymTool? toolById(String id) {
  for (final t in kTools) {
    if (t.id == id) return t;
  }
  return null;
}
