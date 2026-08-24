import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'widgets/account_creation_step.dart';
import 'widgets/auth_choice_step.dart';
import 'widgets/location_permission_step.dart';
import 'widgets/welcome_step.dart';

/// 4-step onboarding: welcome, location permission explainer, auth choice
/// (Google or email), and — only when email is chosen — account creation.
/// Advances only via button taps (NeverScrollableScrollPhysics) — no swiping.
class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final _pageController = PageController();

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            WelcomeStep(onNext: () => _goToStep(1)),
            LocationPermissionStep(onNext: () => _goToStep(2)),
            AuthChoiceStep(onChooseEmail: () => _goToStep(3)),
            AccountCreationStep(onBack: () => _goToStep(2)),
          ],
        ),
      ),
    );
  }
}
