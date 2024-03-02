import 'package:flutter/material.dart';

showSnack(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.cyan,content: Text(title)));
}
