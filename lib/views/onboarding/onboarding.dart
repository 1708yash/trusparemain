
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trusparemain/views/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:trusparemain/views/onboarding/widgets/onboarding_next_button.dart';
import 'package:trusparemain/views/onboarding/widgets/onboarding_page.dart';
import 'package:trusparemain/views/onboarding/widgets/onboarding_skip.dart';

import '../../controllers/onboarding_controller.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // horizontal scroll page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: "assets/images/on_boarding_images/onboardpage1.gif",
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: YImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: YImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),
          // skip button
          const OnBoardingSkip(),
          // dot navigation
          const OnBoardingNavigation(),

          // circular button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}




