import 'package:flutter/material.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/utils/show_snackBar.dart';
import 'package:trusparemain/views/auth/register_screen.dart';
import 'package:trusparemain/views/auth/terms_and_conditions.dart';
import 'package:trusparemain/views/buyers/auth/email_auth.dart';
import 'package:trusparemain/views/buyers/main_screen.dart';

import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);
      if (res == "success") {
        // Check if the current user exists in the buyers collection
        bool userExists = await _authController.checkCurrentUserInBuyers();

        if (userExists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const RegisterScreen()),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnack(context, 'Wrong User Credentials');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnack(context, 'Form not complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        title: const Text('User Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                TextFormField(
                  onChanged: ((value) {
                    email = value;
                  }),
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
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: ((value) {
                    password = value;
                  }),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Password';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
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
                    onPressed: _isLoading ? null : _loginUsers,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do not have account!',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        "Sign-Up",
                        style: TextStyle(
                            color: Colors.cyan, fontSize: 18),
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
