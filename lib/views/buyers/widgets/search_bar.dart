import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
class YSearchBar extends StatelessWidget {
  const YSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon:const Icon(Iconsax.search_normal) ,
        hintText: 'Search your products',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}