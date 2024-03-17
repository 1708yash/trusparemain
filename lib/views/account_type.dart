import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trusparemain/utils/appbar/appbar.dart';
import 'package:trusparemain/utils/constants/image_strings.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/views/vendors/auth/vendor_auth_screen.dart';

import '../utils/helpers/helper_function.dart';
import 'auth/buyers_login_check.dart';

class AccountType extends StatefulWidget {
  const AccountType({super.key});

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const YAppBar(
        title: Text('Select Account Type'),
        showBackArrow: false,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            Image(
              width: YHelperFunctions.screenWidth() * 0.5,
              height: YHelperFunctions.screenHeight() * 0.3,
              image:  const AssetImage(YImages.cycle),
              alignment: Alignment.center,
            ),
            Text(
              "Join Us and be the part of Truspare Family.",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24,),
            Container(
              width: MediaQuery.of(context).size.width - 120,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.cyan.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: ()=> Get.to(()=> const VendorAuthScreen()),
                child: const Text(
                  'Enter as Vendor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),),
            const SizedBox(height: 36),
            Container(
              width: MediaQuery.of(context).size.width - 120,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.cyan.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: ()=> Get.to(()=> const BuyersAuthScreen()),
                child: const Text(
                  'Enter as Buyer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),),
      ),
    );
  }
}
