import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/controllers/auth_controller.dart';
import 'package:trusparemain/utils/show_snackBar.dart';

import '../../utils/constants/sizes.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();

  late String email;

  late String fullName;

  late String phoneNumber;

  late String password;
 Uint8List? _image;
  bool _agreeToTerms = false;
 final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  bool _isLoading = false;
  selectGalleryImage() async {
    Uint8List img =
    await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
  selectCameraImage() async {
    Uint8List img =
    await _authController.pickProfileImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }
  _signUpUser() async {
    setState(() {
      _isLoading =true;
    });
   if(_formKey.currentState!.validate()){
    await _authController.signUpUSers(
         fullName, email, phoneNumber, password,_image,_agreeToTerms).whenComplete((){
           setState(() {
             _formKey.currentState!.reset();
             _isLoading =false;
             _agreeToTerms=false;
           });
    });

    return showSnack(context,'Congratulations, Account Created');
   }else{
     setState(() {
       _isLoading =false;
     });
    return showSnack(context, 'Fields must not be empty');
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _image != null
                        ? Positioned(
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
                            ))
                        : Positioned(
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
                            )),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onChanged: (value) {
                    fullName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Complete Name';
                    } else {
                      return null;
                    }
                  },
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
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Email';
                    } else {
                      return null;
                    }
                  },
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
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Phone Number';
                    } else {
                      return null;
                    }
                  },
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
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a Strong Password';
                    } else {
                      return null;
                    }
                  },
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

                    onPressed: _agreeToTerms ? _signUpUser : null,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.red              ,
                              fontSize: 19,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Radio button for agreeing to terms and conditions
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value as bool;
                        });
                      },
                    ),
                    const Text('I agree to the Terms and Conditions'),
                  ],
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
