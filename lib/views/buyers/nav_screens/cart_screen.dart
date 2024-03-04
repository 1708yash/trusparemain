import 'package:flutter/material.dart';
import 'package:trusparemain/utils/appbar/appbar.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class  CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const YAppBar(
        showBackArrow: false,
        title: Text("Search Here"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const Text("Your Cart is Empty"),
                const SizedBox(height: 24,),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width -120 ,
                  child: const Center(
                    child: Text('Continue Shopping',style: TextStyle(
                      fontSize: 18,color: Colors.white
                    ),),
                  ),
                ),
              ],
            ),),
        ),
      ),
    );
  }
}

