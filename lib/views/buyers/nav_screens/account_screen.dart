import 'package:flutter/material.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

import '../../../utils/appbar/appbar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: YAppBar(
        showBackArrow: false,
        title: Text("Manage Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Text("this is the account screen")
            ],
          ),),
      ),
    );
  }
}