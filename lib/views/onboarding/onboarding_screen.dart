import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
import '../../data/services/onboarding_screen_service.dart';
import 'onboarding_page.dart';
import 'onboarding_page_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageCtrl = PageController();
  int currentPage = 0;
  final storage = OnboardingScreenService();
  bool didFinish = false;

  @override
  void initState() {
    super.initState();
    pageCtrl.addListener(() {
      setState(() {
        currentPage = pageCtrl.page!.round();
      });
    });
  }

  Future<void> _finishOnboarding() async {
    try {
      await storage.setOnboardingSeen();
      debugPrint('onboarding: saved flag true');
    } catch (e, st) {
      debugPrint('onboarding: failed to save flag: $e\n$st');
    }
    if (!mounted) return;
    Future.delayed(Duration.zero, () {
      if (mounted) Navigator.pushReplacementNamed(context, '/authPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageCtrl,
              itemCount: onboardPages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(content: onboardPages[index]);
              },
            ),
          ),

          Padding(
            padding: const .symmetric(vertical: 0),
            child: Row(
              mainAxisAlignment: .center,
              children: List.generate(
                onboardPages.length,
                (index) => buildDot(index),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 40, horizontal: 24),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(color: kNeutral90, fontSize: 14),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (currentPage < onboardPages.length - 1) {
                      pageCtrl.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      _finishOnboarding();
                    }
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const .symmetric(horizontal: 4.0),
      height: 8.0,
      width: currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: currentPage == index ? kOrange : kOrangeAccent300,
        borderRadius: .circular(12.0),
      ),
    );
  }

  @override
  void dispose() {
    pageCtrl.dispose();
    super.dispose();
  }
}
