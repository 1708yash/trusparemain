import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/show_snackBar.dart';
import '../../auth/terms_and_conditions.dart';
import '../main_screen_handler.dart';
import '../phone/phone_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId = '';
  late TextEditingController _phoneNumberController = TextEditingController();
  late TextEditingController _otpController = TextEditingController();

  void _verifyPhoneNumber() async {
    String phoneNumber = '+91${_phoneNumberController.text}'; // Update with country code
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnack(context, 'Phone number verification failed: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      // Authentication successful, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainVendorScreen()),
      );
    } catch (e) {
      showSnack(context, 'Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Through Phone'),
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: TSizes.defaultSpace, right: TSizes.defaultSpace),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsAndConditions()),
            );
          },
          child: const Text('Terms and Conditions *'),
        ),
      ),
      body: Center( // Center the content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text('Send OTP'),
              ),
              const SizedBox(height: 56.0),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text('Verify OTP'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthenticationPage()),
                  );
                },
                child: const Text(
                  'Do not have an account? Sign up',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen'),
      ),
      body: const Center( // Center the content vertically and horizontally
        child: Text('Authentication Successful!'),
      ),
    );
  }
}
