import 'package:flutter/material.dart';
import 'package:trusparemain/utils/appbar/appbar.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class  CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: YAppBar(
        showBackArrow: false,
        title: Text("Search Here"),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Text("this is the cart screen")
            ],
          ),),
      ),
    );
  }
}