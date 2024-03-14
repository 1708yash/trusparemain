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
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No matching products found."));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data!.docs[index];
                      try {
                        return ProductCard(product: product);
                      } catch (e) {
                        print('Error building product card: $e');
                        return const SizedBox();
                      }
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
    String imageURL = product['imageURL'];
    String title = product['productTitle'];
    double priceOfOneItem;
    int minimumQuantity;
    double totalPrice;

    try {
      priceOfOneItem = double.parse(product['priceOfOneItem'].toString());
      minimumQuantity = int.parse(product['minimumQuantity'].toString());
      totalPrice = priceOfOneItem * minimumQuantity;
    } catch (e) {
      print('Error parsing product data: $e');
      // Handle error gracefully, e.g., display default values or placeholder
      return const SizedBox();
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
        child: ListTile(
          leading: Image.network(imageURL, width: 50, height: 50),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text('Price: ₹ ${totalPrice.toStringAsFixed(2)}'),
            ],
          ),
          // Add more details as needed
        ),
      ),
    );
  }
}
