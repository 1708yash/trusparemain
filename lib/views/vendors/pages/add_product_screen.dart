  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'package:flutter/cupertino.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:trusparemain/utils/constants/sizes.dart';
  import 'package:trusparemain/views/vendors/controller/product_controller.dart';

import '../screens/product_upload_screen.dart';

  class AddProductScreen extends StatefulWidget {
    const AddProductScreen({super.key});

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
    //category
  late String _selectedCategory='';
    final List<String> _categoryList = ['kala','peel'];
  //subcategory
    late String _selectedSubCategory='';
    final List<String> _subCategoryList = ['kala','peel'];
    // super subcategory
    //subcategory
    late String _selectedSuperSubCategory='';
    final List<String> _superSubCategoryList = ['kala','peel'];

    Future<void> getCategories() async {
      try {
        QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
        setState(() {
          _categoryList.clear();
          _categoryList
              .addAll(querySnapshot.docs.map((doc) => doc['categoryName'].toString()));

        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching banners: $e');
        }
      }
    }
    Future<void> getSubCategories() async {
      try {
        QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
        setState(() {
          _subCategoryList.clear();
          _subCategoryList
              .addAll(querySnapshot.docs.map((doc) => doc['subCategoryName'].toString()));

        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching banners: $e');
        }
      }
    }
    // super sub categories
    Future<void> getSuperSubCategories() async {
      try {
        QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
        setState(() {
          _superSubCategoryList.clear();
          _superSubCategoryList
              .addAll(querySnapshot.docs.map((doc) => doc['smallSubCategory'].toString()));
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching banners: $e');
        }
      }
    }

    @override
    void initState() {
      super.initState();

      getCategories();
      getSubCategories();
      getSuperSubCategories();
    }
    // Inside _AddProductScreenState

    // submit product in the firestore
    _submitNewProduct() async {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        try {
          // Capture the context before entering the async block
          final currentContext = context;

          if (_productImage != null) {
            String imageDownloadURL = await _productController.uploadImage(_productImage!);
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

            // Show SnackBar using the captured context
            ScaffoldMessenger.of(currentContext).showSnackBar(
              const SnackBar(
                content: Text('Product added successfully'),
                duration: Duration(seconds: 2),
              ),
            );

            // Wait for a brief moment before navigating
            await Future.delayed(const Duration(seconds: 2));

            // Navigate to ProductUploadScreen using the captured context
            Navigator.pushReplacement(
              currentContext,
              MaterialPageRoute(builder: (context) => const ProductUploadScreen()),
            );

            // Reset the form
            _formKey.currentState!.reset();
          } else {
            _formKey.currentState!.reset();
            // Handle case when no image is selected
            print('Please select an image');
            // Reset other variables if needed
          }

        } catch (e) {
          // Handle errors
          print('Error submitting product: $e');
        } finally {
          EasyLoading.dismiss(); // Dismiss loading indicator
        }
      }
    }


    selectGalleryImage() async {
      Uint8List img =
          await _productController.pickStoreImage(ImageSource.gallery);
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _productImage != null
                          ? Image.memory(_productImage!)
                          : IconButton(
                              onPressed: () {
                                selectGalleryImage();
                              },
                              icon: const Icon(CupertinoIcons.photo_camera),
                            ),
                    ),

                    const Text("Upload Product Image"),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        productTitle = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Product Title can not be empty!';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Title',
                        prefixIcon: const Icon(Icons.store),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                            onChanged: (value) {
                              priceOfOneItem = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Price can not be empty!';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price of one item',
                        prefixIcon: const Icon(Icons.store),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        minimumQuantity = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Minimum can not be empty!';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Minimum Quantity to sell in single Order',
                        prefixIcon: const Icon(Icons.store),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    const Text(
                      'Select type and category ',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // category selector
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Category',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [

                            DropdownButton<String>(
                              value: _selectedCategory.isNotEmpty ?_selectedCategory:null,
                              items: _categoryList.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedCategory = value ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Select Sub-Category',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [

                            DropdownButton<String>(
                              value: _selectedSubCategory.isNotEmpty ?_selectedSubCategory:null,
                              items: _subCategoryList.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedSubCategory = value ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                        // superSubcategory
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Select Super-Sub-Category',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            DropdownButton<String>(
                              value: _selectedSuperSubCategory.isNotEmpty ?_selectedSuperSubCategory:null,
                              items: _superSubCategoryList.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedSuperSubCategory = value ?? '';
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    const Text('Provide Product Description',style:TextStyle(fontSize: 20),),
                    TextFormField(
                      onChanged: (value) {
                        productDescription = value;
                      },
                      maxLines: 5, // Adjust the number of lines as needed
                      decoration: InputDecoration(
                        labelText: 'Product Description',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24,),
                    Container(
                      width: MediaQuery.of(context).size.width - 120,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: (){_submitNewProduct();},
                        child: const Text(
                          'Submit New Product',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // good text do not delete this
                    // const SizedBox(height: 20.0),
                    // Text(_selectedCategory.isEmpty
                    //     ? 'No category selected'
                    //     : 'Selected category: $_selectedCategory'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
