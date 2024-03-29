import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/views/buyers/nav_screens/search_screen.dart';
import 'package:trusparemain/views/buyers/widgets/banners.dart';
import 'package:trusparemain/views/auth/widgets/product_detail_card.dart';
import '../../../utils/appbar/appbar.dart';
import '../../../utils/constants/sizes.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const YAppBar(
        showBackArrow: false,
        title: Text("Welcome"),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white // Light mode background color
            : Colors.black, // Dark mode background color
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(

              right: TSizes.defaultSpace,
              left: TSizes.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: TSizes.spaceBetweenItems),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Search Products',
                        hintText: 'Search Products...',
                        prefixIcon: Icon(Icons.search),

                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Banners(),
                const SizedBox(height: TSizes.spaceBetweenItems),
                // Featured Products
                _buildSectionTitle(context, 'Featured Products'),
                _buildProductCardsSection(context, 'products'),
                const SizedBox(height: 20),
                // Recently Added
                _buildSectionTitle(context, 'Recently Added'),
                _buildProductCardsSection(context, 'products'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.cyan, // Title text color
        ),
      ),
    );
  }

  Widget _buildProductCardsSection(BuildContext context, String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data!.docs.map((doc) {
                final imageURL = doc['imageURL'] as String?;
                final productTitle = doc['productTitle'] as String?;
                final minimumQuantity = _parseDouble(doc['minimumQuantity']);
                final priceOfOneItem = _parseDouble(doc['priceOfOneItem']);

                final productID = doc.id; // Fetch product ID from document ID

                return GestureDetector(
                  onTap: () {
                    // Navigate to ProductDetailPage with productID parameter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productID: productID),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyanAccent.withOpacity(0.2), // Product card background color
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageURL ?? '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productTitle ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${priceOfOneItem.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Minimum order: ${minimumQuantity.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }
}
