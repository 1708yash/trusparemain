import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/views/vendors/auth/vendor_registration_screen.dart';
import 'package:trusparemain/views/vendors/main_screen_handler.dart';

class VendorAuthScreen extends StatefulWidget {
  const VendorAuthScreen({super.key});

  @override
  State<VendorAuthScreen> createState() => _VendorAuthScreenState();
}

class _VendorAuthScreenState extends State<VendorAuthScreen> {

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _checkIfUserIsVendor(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('vendors').doc(userId).get();
    return snapshot.exists;
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
            return const VendorRegistrationScreen();
          } else {
            // User is authenticated
            return FutureBuilder<bool>(
              future: _checkIfUserIsVendor(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bool isVendor = snapshot.data ?? false;
                if (isVendor) {
                  // User is a vendor, navigate to main vendor screen
                  return const MainVendorScreen();
                } else {
                  // User is not a vendor, navigate to registration screen
                  return const VendorRegistrationScreen();
                }
              },
            );
          }
        },
      ),
    );
  }
}
