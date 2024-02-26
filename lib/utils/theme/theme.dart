import 'package:flutter/material.dart';
import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/outlined_button.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';


class YAppTheme{
  YAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: YTextTheme.lightTextTheme,
      elevatedButtonTheme: YElevatedButtonTheme.lightElevatedButtonTheme,
    chipTheme: YChipTheme.lightChipTheme,
    appBarTheme: YAppBarTheme.lightAppBarTheme,
    checkboxTheme: YCheckboxThemeData.lightCheckboxTheme,
    bottomSheetTheme: YBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: YOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: YTextFormFieldTheme.lightInputDecorationTheme,

    );
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: "Poppins",
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: YTextTheme.darkTextTheme,
      elevatedButtonTheme: YElevatedButtonTheme.darkElevatedButtonTheme,
    checkboxTheme: YCheckboxThemeData.darkCheckboxTheme,
    chipTheme: YChipTheme.darkChipTheme,
    appBarTheme: YAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: YBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: YOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: YTextFormFieldTheme.darkInputDecorationTheme,
  );
}