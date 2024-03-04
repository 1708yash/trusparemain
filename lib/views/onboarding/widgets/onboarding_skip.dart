import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utilities.dart';
import '../../../controllers/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: YDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(
          onPressed: ()=> OnBoardingController.instance.skipPage(),
          child: const Text('Skip'),
        ));
  }
}
