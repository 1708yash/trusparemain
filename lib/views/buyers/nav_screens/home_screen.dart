import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/views/auth/widgets/product_detail_card.dart';

import 'package:trusparemain/views/buyers/widgets/banners.dart';
import 'package:trusparemain/views/buyers/widgets/category_text.dart';
import '../../../utils/appbar/appbar.dart';
import '../../../utils/constants/sizes.dart';
import '../widgets/search_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YAppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.leave_bags_at_home),
          )
        ],
        showBackArrow: false,
        title: const Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            right: TSizes.defaultSpace,
            left: TSizes.defaultSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YSearchBar(),
              const SizedBox(
                height: TSizes.spaceBetweenItems,
              ),
              const Banners(),
              const SizedBox(
                height: 20,
              ),
              const CategoryText(),
              const SizedBox(
                height: TSizes.spaceBetweenItems,
              ),
              FutureBuilder(
                future: fetchRecentProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Display the list of product cards
                  return SizedBox(
                    height: 600.0, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length > 4 ? 4 : snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data?[index];

                        // Fetch values from the document
                        String title = product?['productTitle'];
                        String imageUrl = product?['imageURL'];
                        double priceOfOneItem = double.parse(product?['priceOfOneItem']);
                        int minimumQuantity = int.parse(product?['minimumQuantity']);
                        String category = product?['category'];
                        String productID= product?['productID'];

                        // Calculate the total price
                        double totalPrice = priceOfOneItem * minimumQuantity;

                        return Expanded(
                          child: ProductCard(
                            imageUrl: imageUrl,
                            title: title,
                            price: totalPrice,
                            category:category,
                            onTap: () {
                              // Handle the tap on the product card
                              // You can navigate to a product details page or perform other actions here
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return  ProductDetailPage(productID: productID);
                                  }));
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> fetchRecentProducts() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('products').get();
      return snapshot.docs;
    } catch (e) {
      print("Error fetching recent products: $e");
      return [];
    }
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final VoidCallback onTap;
  final String category;

  const ProductCard({super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTap,
    required this.category,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the product image
            const SizedBox(height: 4,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8.0)),
                child: Image.network(
                  imageUrl,
                  width: 120.0,
                  height: 80.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            // Display the product title and price
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$$price',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
                ),
                Text(
                  category,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

