import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
import 'onboarding_page_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData content;
  const OnboardingPage({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_onboarding.png', width: 150),
              const SizedBox(height: 32),
              Image.asset(
                content.imagePath,
                width: double.infinity,
                height: 400,
              ),
              const SizedBox(height: 69),
              Text(
                content.title,
                style: TextStyle(
                  color: kNeutral100,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                content.description,
                style: TextStyle(
                  color: kNeutral100,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
