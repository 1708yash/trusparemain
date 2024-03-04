import 'package:flutter/material.dart';
import 'package:trusparemain/views/vendors/auth/vendor_registration_screen.dart';

import 'auth_functions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ======== Full Name ========

              // ======== Email ========
              TextFormField(
                key: const ValueKey('email'),
                decoration: InputDecoration(
                    labelText: 'Enter Email',
                    prefixIcon: const Icon(Icons.email), // Add prefix icon
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please Enter valid Email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
              ),
              const SizedBox(height: 24,),
              // ======== Password ========
              TextFormField(
                key: const ValueKey('password'),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Please Enter Password of min length 6';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 120,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.cyan.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      login
                          ? AuthServices.signinUser(email, password, context)
                          :  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VendorRegistrationScreen()));
                    }
                  },
                  child:Text(login ? 'Login' : 'Signup',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: Text(login
                      ? "Don't have an account? Signup"
                      : "Already have an account? Login"))
            ],
          ),
        ),
      ),
    );
  }
}