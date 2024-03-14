import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            icon: const Icon(Icons.logout),
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
              SizedBox(height: TSizes.spaceBetweenItems),
              const Banners(),
              const SizedBox(height: 20),
              const CategoryText(),
              const SizedBox(height: TSizes.spaceBetweenItems),
              // Featured Products
              _buildSectionTitle('Featured Products'),
              _buildProductCardsSection(context, 'products'),
              const SizedBox(height: 20),
              // Recently Added
              _buildSectionTitle('Recently Added'),
              _buildProductCardsSection(context, 'products'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
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
                final minimumOrderValue = minimumQuantity * priceOfOneItem;

                return GestureDetector(
                  onTap: () {
                    // Handle tap on the product card
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '₹${priceOfOneItem.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Minimum order: ${minimumQuantity.toStringAsFixed(2)}',
                                style: TextStyle(
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
