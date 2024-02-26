
import 'package:flutter/material.dart';
import 'package:trusparemain/utils/constants/colors.dart';

class YShadowStyle{
  static final verticalProductShadows =BoxShadow(
    color: YColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadows =BoxShadow(
    color: YColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}