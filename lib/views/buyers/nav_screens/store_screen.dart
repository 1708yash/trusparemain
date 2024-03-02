import 'package:flutter/material.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

import '../../../utils/appbar/appbar.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: YAppBar(
        showBackArrow: false,
        title: Text("Your Store"),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Text("this is the store screen")
            ],
          ),),
      ),
    );
  }
}