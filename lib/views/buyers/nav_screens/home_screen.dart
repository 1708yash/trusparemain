import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:trusparemain/views/buyers/widgets/banners.dart';
import 'package:trusparemain/views/buyers/widgets/category_text.dart';
import '../../../utils/appbar/appbar.dart';
import '../../../utils/constants/sizes.dart';
import '../widgets/search_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: YAppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.leave_bags_at_home))
        ],
        showBackArrow: false,
        title: const Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,right: TSizes.defaultSpace,left: TSizes.defaultSpace),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YSearchBar(),
              SizedBox(
                height: TSizes.spaceBetweenItems,
              ),
              Banners(),
              SizedBox(
                height: TSizes.spaceBetweenItems,
              ),
              CategoryText(),
            ],
          ),
        ),
      ),
    );
  }
}
