import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:trusparemain/views/auth/register_screen.dart';

import '../buyers/main_screen.dart';

class BuyersAuthScreen extends StatefulWidget {
  const BuyersAuthScreen({super.key});
  @override
  State<BuyersAuthScreen> createState() => _BuyersAuthScreenState();
}

class _BuyersAuthScreenState extends State<BuyersAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MainScreen();
            } else {
              return const RegisterScreen();
            }
          },
        )
    );
  }
}
