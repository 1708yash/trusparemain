import 'package:flutter/material.dart';

TextField reusableTextField(String text,IconData icon,bool isPasswordType,TextEditingController controller){
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    decoration: InputDecoration(
      labelText: text,
      prefixIcon: Icon(icon,color: Colors.grey,),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)),

    ),
keyboardType: isPasswordType? TextInputType.visiblePassword:TextInputType.emailAddress,
  );
}