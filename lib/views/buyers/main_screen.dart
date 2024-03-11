import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'nav_screens/account_screen.dart';
import 'nav_screens/cart_screen.dart';
import 'nav_screens/home_Screen.dart';
import 'nav_screens/search_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const Home(),
    const CartScreen(),
    const SearchScreen(),
    const AccountScreen()
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
                icon: Icon(Iconsax.shopping_cart, size: 24), label: "Cart"),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.search_normal, size: 24), label: "Search"),
            const BottomNavigationBarItem(
                icon: Icon(Iconsax.user, size: 24), label: "Account"),
          ]),
      body: _pages[_pageIndex],
    );
  }
}