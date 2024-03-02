import 'package:flutter/material.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/utils/show_snackBar.dart';
import 'package:trusparemain/views/auth/register_screen.dart';
import 'package:trusparemain/views/buyers/main_screen.dart';

import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  final AuthController _authController =AuthController();
  _loginUsers() async{
    if(_formKey.currentState!.validate()){
  String res =await _authController.loginUsers(email, password);
  if(res =="success"){
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
      return MainScreen();
    }));
  } else{
    return showSnack(context, 'Wrong User Credentials');
  }
    }
    else{
      return showSnack(context, 'Form not complete');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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

                SizedBox(height: 100,),
                //email field
                TextFormField(
                  onChanged: ((value){
                    email =value;
                  }),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Enter Email';
                    }
                    else{return null;}
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter Email',
                      prefixIcon: const Icon(Icons.email), // Add prefix icon
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),

                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: ((value){
                    password =value;
                  }),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Enter Password';
                    }
                    else{return null;}
                  },
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
                    onPressed: _loginUsers,
                    child:const Text(
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
                    const Text('Do not have account!',style: TextStyle(fontSize: 16),),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const RegisterScreen();
                      }));
                    }, child: Text("Sign-Up",style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 18
                    ),))
                  ],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
