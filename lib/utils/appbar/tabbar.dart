
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_function.dart';
import '../device/device_utilities.dart';


class YTabBar extends StatelessWidget implements PreferredSizeWidget {
  const YTabBar({
    super.key, required this.tabs,
  });

  final List<Widget> tabs;
  @override
  Widget build(BuildContext context) {
    final dark =YHelperFunctions.isDarkMode(context);
    return Material(
      color: dark? YColors.black:YColors.white,
      child: TabBar(
        isScrollable: true,
        indicatorColor: YColors.primaryColor,
        unselectedLabelColor: YColors.darkGrey,
        labelColor:dark ?YColors.white: YColors.primaryColor,
        tabs: tabs),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(YDeviceUtils.getAppBarHeight());

}