import 'package:get_storage/get_storage.dart';

import 'onboarding_service.dart';

class OnboardingServiceImpl implements OnboardingService {
  final box = GetStorage();

  @override
  void dontShowAgain() {
    box.write('showOnboarding', false);
  }

  @override
  bool showOnboarding() {
    return box.read('showOnboarding') as bool;
  }
}
