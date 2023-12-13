import 'package:umt_timetable/model/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> data = [
    OnboardingModel(
      animUrl: 'assets/lottie/scheduleAnim.json',
      title: 'Welcome to UMT Timetable',
      description:
          'Welcome to [App Name], where organizing your time is just a tap away! Get ready to transform the way you plan your days with our smart, user-friendly timetable generator.',
    ),
    OnboardingModel(
      animUrl: 'assets/lottie/clockAnim.json',
      title: 'Tailored to Your Needs',
      description:
          'Personalize your schedule like never before. From classes to extracurriculars, [App Name] adapts to your lifestyle, ensuring you\'re always on top of your commitments with minimal effort.',
    ),
    OnboardingModel(
        animUrl: 'assets/lottie/bookAnim.json',
        title: 'Stay Ahead, Stay Organized',
        description:
            'Say goodbye to the chaos of planning. With [App Name], you\'ll have a clear view of your weekly activities, receive timely reminders, and manage your time efficiently, all in one click!')
  ];
}
