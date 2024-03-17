import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

import '../../auth/widgets/product_detail_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final int maxProductsToShow = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Product Here"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search Products...',
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: getProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No matching products found."));
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Set the number of grid columns
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data!.docs[index];
                      return ProductCard(product: product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getProductsStream() {
    Query productsQuery = FirebaseFirestore.instance.collection('products');

    // Apply filters based on search query
    if (searchQuery.isNotEmpty) {
      productsQuery = productsQuery.where('productTitle', isGreaterThanOrEqualTo: searchQuery);
    }

    // Limit the number of products to show
    productsQuery = productsQuery.limit(maxProductsToShow);

    return productsQuery.snapshots();
  }
}

class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageURL = product['imageURL'] ?? '';
    String title = product['productTitle'] ?? '';
    double priceOfOneItem = 0.0;
    int minimumQuantity = 0;
    double totalPrice = 0.0;

    try {
      priceOfOneItem = double.parse(product['priceOfOneItem'].toString());
      minimumQuantity = int.parse(product['minimumQuantity'].toString());
      totalPrice = priceOfOneItem * minimumQuantity;
    } catch (e) {
      return const SizedBox(); // Return an empty SizedBox if an error occurs
    }

    return GestureDetector(
      onTap: () {
        String productID = product.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productID: productID),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.network(
                  imageURL,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Price: ₹ ${totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
