import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/utils/show_snackBar.dart';
import 'package:trusparemain/views/auth/login_screen.dart';

import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _AuthController();
}

class _AuthController extends State<RegisterScreen> {
  final AuthController _registrationController = AuthController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  Uint8List? _image;

  _register() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await _registrationController
            .registerWithEmailAndPassword(
          fullNameController.text,
          emailController.text,
          phoneNumberController.text,
          passwordController.text,
        )
            .whenComplete(() {
          setState(() {
            _formKey.currentState!.reset();
            _isLoading = false;
          });
        });

        // Registration successful, navigate to the desired screen
        // For example, navigate to the home screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        // Handle registration errors (display an error message or toast)
      }
      return showSnack(
          context, "Congratulation your account was created successfully");
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Fields must no be empty');
    }
  }

  selectGalleryImage() async {
    Uint8List img =
        await _registrationController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  selectCameraImage() async {
    Uint8List img =
        await _registrationController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Register Here'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: TSizes.defaultSpace, right: TSizes.defaultSpace),
        child: TextButton(
            onPressed: () {}, child: const Text('Terms and Conditions *')),
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
                  _image!=null ?  CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.cyan.shade400,
                    backgroundImage: MemoryImage(_image!),
                    ):CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.cyan.shade400,
                  ),
                    _image!=null ?  Positioned(
                        right: 25,
                        top: 20,
                        child: IconButton(
                          color: Colors.white,

                          onPressed: () {
                            selectGalleryImage();
                          },
                          icon: const Opacity(
                            opacity: 0.2,
                            child: Icon(
                              Iconsax.camera,
                              size: 60,
                            ),
                          ),
                        )
                    )
            :Positioned(
                        right: 25,
                        top: 20,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            selectGalleryImage();
                          },
                          icon: const Icon(
                            Iconsax.camera,
                            size: 60,
                          ),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Complete Name';
                    } else {
                      return null;
                    }
                  },
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Email';
                    } else {
                      return null;
                    }
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Phone Number';
                    } else {
                      return null;
                    }
                  },
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Strong Password';
                    } else {
                      return null;
                    }
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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
                    onPressed: _register,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already Have an account !',
                        style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }));
                      },
                      child: const Text(
                        "SignIn",
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
