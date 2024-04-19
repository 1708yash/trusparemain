import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/views/buyers/main_screen.dart';

import '../buyers/auth/email_auth.dart';

class BuyersAuthScreen extends StatefulWidget {
  const BuyersAuthScreen({Key? key});

  @override
  State<BuyersAuthScreen> createState() => _BuyersAuthScreenState();
}

class _BuyersAuthScreenState extends State<BuyersAuthScreen> {
  // ignore: unused_field
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<bool> _checkIfUserIsBuyer(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('buyers')
        .where('buyerId', isEqualTo: userId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final User? user = snapshot.data;
          if (user == null) {
            // User is not authenticated, navigate to registration screen
            return const SignupPage();
          } else {
            // User is authenticated
            return FutureBuilder<bool>(
              future: _checkIfUserIsBuyer(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bool isBuyer = snapshot.data ?? false;
                if (isBuyer) {
                  // User is a buyer, navigate to main buyer screen
                  return const MainScreen();
                } else {
                  // User is not a buyer, navigate to registration screen
                  return const SignupPage();
                }
              },
            );
          }
        },
      ),
    );
  }
}
