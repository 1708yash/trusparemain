import 'package:flutter/material.dart';

class VendorOrderScreen extends StatelessWidget {
  const VendorOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('this is orders page for vendor')
          ],
        ),
      ),
    );
  }
}
