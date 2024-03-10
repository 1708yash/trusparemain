// product_model.dart

import 'dart:typed_data';

class Product {
  late String title;
  late double mrp;
  late double offeredPrice;
  late int minQuantity;
  Uint8List? image1;
  Uint8List? image2;
  Uint8List? image3;
  late String category;
  late String subCategory;
  late String smallSubCategory;
  late String description;
  late bool isAvailable;

  Product({
    required this.title,
    required this.mrp,
    required this.offeredPrice,
    required this.minQuantity,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.category,
    required this.subCategory,
    required this.smallSubCategory,
    required this.description,
    required this.isAvailable,
  });
}
