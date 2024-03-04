import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import '../../buyers/nav_screens/home_Screen.dart';
import '../login_screen.dart';

class LoginStateCheck extends StatefulWidget {
  const LoginStateCheck({super.key});

  @override
  State<LoginStateCheck> createState() => _LoginStateCheckState();
}

class _LoginStateCheckState extends State<LoginStateCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const LoginScreen();
            }
          },
        )
    );
  }
}
