import 'package:flutter/material.dart';

class VendorStoreScreen extends StatelessWidget {
  const VendorStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('this is store page for vendor')
          ],
        ),
      ),
    );
  }
}
