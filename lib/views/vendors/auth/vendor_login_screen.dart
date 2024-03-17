
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
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

        // Check if the user's email is verified
        if (userCredential.user!.emailVerified) {
          // Navigate to the home page or perform other actions upon successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainVendorScreen()),
          );
        } else {
          // If email is not verified, show a message to the user
          showSnack(context, 'Please verify your email before logging in');
        }
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
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 120,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.cyan.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(

                onPressed: _signInWithEmailAndPassword,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
  }}