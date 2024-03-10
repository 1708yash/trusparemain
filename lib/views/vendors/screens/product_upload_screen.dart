import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:trusparemain/views/vendors/pages/add_product_screen.dart';

class ProductUploadScreen extends StatelessWidget {
  const ProductUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .doc(user?.uid)
            .collection('products')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  for (var doc in snapshot.data!.docs)
                    _buildProductCard(
                      context,
                      doc.id, // Document ID for deletion
                      doc['imageURL'],
                      doc['productTitle'],
                      doc['priceOfOneItem'].toString(),
                      user,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context,
      String documentId,
      String imageUrl,
      String title,
      String price,
      User? user,
      ) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Image.network(imageUrl, height: 100, width: 100, fit: BoxFit.cover),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 4),
            Text('Price: \$ $price'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              // Delete the product from Firebase
              FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(user?.uid)
                  .collection('products')
                  .doc(documentId)
                  .delete()
                  .then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted successfully')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete product: $error')),
                );
              });
            }
          },
        ),
      ),
    );
  }
}
