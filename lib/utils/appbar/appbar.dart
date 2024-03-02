
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../device/device_utilities.dart';
import '../helpers/helper_function.dart';

class YAppBar extends StatelessWidget implements PreferredSizeWidget {
  const YAppBar(
      {super.key,
      this.title,
      this.showBackArrow = true,
      this.leadingIcon,
      this.actions,
      this.leadingOnPressed,});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override

  Widget build(BuildContext context) {
    final dark = YHelperFunctions.isDarkMode(context);
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () =>  Navigator.of(context).pop(),
                icon: Icon(Iconsax.arrow_left,color: dark?YColors.white:YColors.dark,))
            :leadingIcon !=null? IconButton(
                onPressed: leadingOnPressed,
                icon:  Icon(leadingIcon)):null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(YDeviceUtils.getAppBarHeight());
}
