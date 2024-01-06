import 'package:umt_timetable/model/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> data = [
    OnboardingModel(
      animUrl: 'assets/lottie/scheduleAnim.json',
      title: 'Welcome to Marine Scheduler',
      description:
          'Welcome to Marine Scheduler, where organizing your time is just a tap away!',
    ),
    OnboardingModel(
      animUrl: 'assets/lottie/clockAnim.json',
      title: 'Tailored to Your Needs',
      description:
          'Personalize your schedule like never before. From classes to extracurriculars.',
    ),
    OnboardingModel(
        animUrl: 'assets/lottie/bookAnim.json',
        title: 'Stay Ahead, Stay Organized',
        description:
            'Say goodbye to the chaos of planning. With Marine Scheduler, you\'ll manage your time efficiently, all in one click!')
  ];
}
