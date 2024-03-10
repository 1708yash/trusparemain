import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trusparemain/utils/theme/theme.dart';
import 'package:trusparemain/views/onboarding/onboarding.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Truspare',
      themeMode: ThemeMode.system,
      theme: YAppTheme.lightTheme,
      darkTheme: YAppTheme.darkTheme,
      home:   const OnBoardingScreen(),
      builder: EasyLoading.init(),
    );
  }
}
