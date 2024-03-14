import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/controllers/auth_controller.dart';
import 'package:trusparemain/utils/show_snackBar.dart';

import '../../utils/constants/sizes.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String fullName = '';
  String phoneNumber = '';
  String password = '';

  Uint8List? _image;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  void _selectGalleryImage() async {
    Uint8List? img = await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }


  Future<void> _signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      await _authController
          .signUpUSers(fullName, email, phoneNumber, password, _image, _agreeToTerms)
          .whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
          _agreeToTerms = false;
        });
      });

      showSnack(context, 'Congratulations, Account Created');
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnack(context, 'Please fill all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Here'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: TSizes.defaultSpace, right: TSizes.defaultSpace),
        child: TextButton(
          onPressed: () {},
          child: const Text('Terms and Conditions *'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.cyan.shade400,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.cyan.shade400,
                    ),
                    Positioned(
                      right: 25,
                      top: 20,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: _selectGalleryImage,
                        icon: const Icon(Iconsax.camera, size: 60),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onChanged: (value) => fullName = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                  decoration: const InputDecoration(
                    labelText: 'Enter Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) => email = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) => phoneNumber = value,
                  validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                  decoration: const InputDecoration(
                    labelText: 'Enter Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) => password = value,
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Please enter a strong password' : null,
                  decoration: const InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: _agreeToTerms ? _signUpUser : null,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Checkbox for agreeing to terms and conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) => setState(() => _agreeToTerms = value!),
                    ),
                    const Text('I agree to the Terms and Conditions'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already Have an Account! ', style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
