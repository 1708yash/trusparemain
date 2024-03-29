import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:trusparemain/utils/theme/theme.dart';
import 'package:trusparemain/views/onboarding/onboarding.dart';
import 'package:trusparemain/views/account_type.dart'; // Import the AccountType page
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

void main() async {
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
      initialBinding: MyAppBinding(), // Initialize bindings
      title: 'Truspare',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: YAppTheme.lightTheme,
      darkTheme: YAppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: MyAppHome(), // Placeholder while initializing
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}
class MyAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyAppController()); // Initialize MyAppController
  }
}

class MyAppController extends GetxController {
  // Track authentication status
  RxBool isAuth = false.obs; // Use RxBool for reactive updates

  @override
  void onInit() {
    super.onInit();
    // Check authentication status when controller is initialized
    checkAuthStatus();
  }

  // Function to check authentication status
  void checkAuthStatus() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // If user is authenticated, set isAuth to true
      isAuth.value = true;
    } else {
      // If user is not authenticated, set isAuth to false
      isAuth.value = false;
    }
  }
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAppController>(
      builder: (controller) {
        if (controller.isAuth.isTrue) {
          // If user is authenticated, navigate to AccountType page
          return const AccountType();
        } else {
          // If user is not authenticated, continue with OnBoardingScreen
          return const OnBoardingScreen();
        }
      },
    );
  }
}
