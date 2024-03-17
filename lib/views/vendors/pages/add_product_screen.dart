import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/views/vendors/controller/product_controller.dart';
import '../screens/product_upload_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController _productController = ProductController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _productImage;
  late String productTitle;
  late String productDescription;
  late String priceOfOneItem;
  late String minimumQuantity;
  late String _selectedCategory = '';
  final List<String> _categoryList = ['kala', 'peel'];
  late String _selectedSubCategory = '';
  final List<String> _subCategoryList = ['kala', 'peel'];
  late String _selectedSuperSubCategory = '';
  final List<String> _superSubCategoryList = ['kala', 'peel'];

  @override
  void initState() {
    super.initState();
    getCategories();
    getSubCategories();
    getSuperSubCategories();
  }

  Future<void> getCategories() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('categories').get();
      setState(() {
        _categoryList.clear();
        _categoryList.addAll(
            querySnapshot.docs.map((doc) => doc['categoryName'].toString()));
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> getSubCategories() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('categories').get();
      setState(() {
        _subCategoryList.clear();
        _subCategoryList.addAll(
            querySnapshot.docs.map((doc) => doc['subCategoryName'].toString()));
      });
    } catch (e) {
      print('Error fetching sub-categories: $e');
    }
  }

  Future<void> getSuperSubCategories() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('categories').get();
      setState(() {
        _superSubCategoryList.clear();
        _superSubCategoryList.addAll(querySnapshot.docs
            .map((doc) => doc['smallSubCategory'].toString()));
      });
    } catch (e) {
      print('Error fetching super sub-categories: $e');
    }
  }

  _submitNewProduct() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        final currentContext = context;

        if (_productImage != null) {
          String imageDownloadURL =
          await _productController.uploadImage(_productImage!);
          await _productController.addProduct(
            productTitle: productTitle,
            productDescription: productDescription,
            priceOfOneItem: priceOfOneItem,
            minimumQuantity: minimumQuantity,
            category: _selectedCategory,
            subCategory: _selectedSubCategory,
            superSubCategory: _selectedSuperSubCategory,
            imageDownloadURL: imageDownloadURL,
          );

          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(builder: (context) => const ProductUploadScreen()),
          );

          _formKey.currentState!.reset();
        } else {
          print('Please select an image');
        }
      } catch (e) {
        print('Error submitting product: $e');
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  selectGalleryImage() async {
    Uint8List img = await _productController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _productImage = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    selectGalleryImage();
                  },
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _productImage != null
                        ? Image.memory(_productImage!)
                        : const Icon(Icons.add_photo_alternate),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Upload Product Image"),
                const SizedBox(height: 24),
                TextFormField(
                  onChanged: (value) {
                    productTitle = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product Title can not be empty!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Product Title',
                    prefixIcon: const Icon(Icons.store),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) {
                    priceOfOneItem = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price can not be empty!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price of one item',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) {
                    minimumQuantity = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Minimum Quantity can not be empty!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Minimum Quantity',
                    prefixIcon: const Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Selector
                DropdownButtonFormField<String>(
                  value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: _categoryList.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Sub-Category Selector
                DropdownButtonFormField<String>(
                  value: _selectedSubCategory.isNotEmpty ? _selectedSubCategory : null,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedSubCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a sub-category';
                    }
                    return null;
                  },
                  items: _subCategoryList.map((subCategory) {
                    return DropdownMenuItem<String>(
                      value: subCategory,
                      child: Text(subCategory),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Sub-Category',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Super Sub-Category Selector
                DropdownButtonFormField<String>(
                  value: _selectedSuperSubCategory.isNotEmpty ? _selectedSuperSubCategory : null,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedSuperSubCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a super sub-category';
                    }
                    return null;
                  },
                  items: _superSubCategoryList.map((superSubCategory) {
                    return DropdownMenuItem<String>(
                      value: superSubCategory,
                      child: Text(superSubCategory),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Super Sub-Category',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  onChanged: (value) {
                    productDescription = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product Description can not be empty!';
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitNewProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan, // Background color
                    padding: const EdgeInsets.symmetric(horizontal: 20), // Padding
                  ),
                  child: const Text('Submit New Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
