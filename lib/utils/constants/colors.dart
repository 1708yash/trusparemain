import 'package:flutter/material.dart';

class YColors{
  YColors._();
  /// app colors
  static const Color primaryColor = Color(0xFF4B68FF);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);
  
  /// text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textWhite = Colors.white;
  
  /// background colors

 static const Color light = Color(0xFFF6F6F6);
 static const Color dark = Color(0xFF272727);
 static const Color primaryBackground = Color(0xFFF3F5FF);
 
 /// background container color
static const Color lightContainer =Color(0xFFF6F6F6);
  static const Color darkContainer = Colors.white;

  //Button colors
static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C7570);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // border colors
static const borderPrimary = Color(0xFFD9D9D9);
  static const borderSecondary = Color(0xFFE6E6E6);

  // error and validation colors
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const warning = Color(0xFFF57C00);
  static const info = Color(0xFF1976D2);

  //Neutral Shades
  static const black = Color(0xFF232323);
  static const darkerGrey = Color(0xFF4F4F4F);
  static const darkGrey = Color(0xFF939393);
  static const grey = Color(0xFFE0E0E0);
  static const softGrey = Color(0xFFF4F4F4);
  static const lightGrey = Color(0xFFF9F9F9);
  static const white = Color(0xFFFFFFFF);

  //gradient color
static const Gradient lineGradient = LinearGradient(
  begin: Alignment(0.0, 0.0),
  end: Alignment(0.707, -0.707),
  colors:
[
  Color(0xffff9a9e),
  Color(0xfffad0c4),
  Color(0xfffad0c4),
],);
}
