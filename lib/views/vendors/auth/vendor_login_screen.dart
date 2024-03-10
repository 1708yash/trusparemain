
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/show_snackBar.dart';
import 'package:trusparemain/views/vendors/auth/vendor_registration_screen.dart';

import '../main_screen_handler.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  _VendorLoginScreenState createState() => _VendorLoginScreenState();
}
class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signInWithEmailAndPassword() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        // Navigate to the home page or perform other actions upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainVendorScreen()),
        );
      } catch (e) {
        e.toString();
        showSnack(context, 'User not found');
        // Handle authentication errors here
      }

    } else {
      // Handle empty fields
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Do not have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VendorRegistrationScreen()));
                  },
                  child: const Text('Signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}