import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trusparemain/views/vendors/screens/landing_screen.dart';
import 'package:trusparemain/views/vendors/screens/orders_screen.dart';
import 'package:trusparemain/views/vendors/screens/product_upload_screen.dart';
import 'package:trusparemain/views/vendors/screens/vendor_account_screen.dart';
import 'package:trusparemain/views/vendors/screens/vendor_store_screen.dart';
class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const LandingScreen(),
    const VendorOrderScreen(),
    const VendorStoreScreen(),
    const ProductUploadScreen(),
    const VendorAccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          unselectedItemColor: Colors.grey.shade400,
          selectedItemColor: Colors.green.shade700,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24, color: Colors.grey.shade400,),
              label: "Home",
              activeIcon: const Icon(Iconsax.home, size: 24),),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.menu, size: 24), label: "Orders"),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.shop, size: 24), label: "Store"),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.box, size: 24), label: "Products"),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.setting, size: 24), label: "Account"),
          ]),
      body: _pages[_pageIndex],
    );
  }
}