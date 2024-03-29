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
        title: const Text("Your Products"),automaticallyImplyLeading: false,
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
            return const Center(child: Text("No products available", style: TextStyle(color: Colors.cyan)));
          }

          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                return _buildProductCard(
                  context,
                  doc.id, // Document ID for deletion
                  doc['imageURL'],
                  doc['productTitle'],
                  doc['priceOfOneItem'].toString(),
                  user,
                );
              },
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
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, height: 100, width: 100, fit: BoxFit.cover),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Price: ₹$price', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.black),
          onPressed: () {
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
          },
        ),
      ),
    );
  }
}
