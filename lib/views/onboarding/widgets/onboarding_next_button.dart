
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utilities.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../../controllers/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark =YHelperFunctions.isDarkMode(context);
    return Positioned(
        right: TSizes.defaultSpace,
        bottom: YDeviceUtils.getBottomNavigationHeight(),
        child: ElevatedButton(
          onPressed: ()=>OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor:dark ? YColors.primaryBackground:Colors.black),
          child: const Icon(Iconsax.arrow_circle_right),
        ));
  }
}
