import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
      appBar: const YAppBar(
        showBackArrow: false,
        title: Text("Welcome"),
        actions: [
          Row(
            children: [
              Icon(Iconsax.shopping_bag,)
            ],
          )
        ],
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
