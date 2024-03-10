import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.leave_bags_at_home),
          )
        ],
        title: const Text('Welcome'),
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildVendorDetails(),
              const SizedBox(height: 20),
              const Text(
                'Make Sure to add Bank Details before adding products to your store!',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.cyan), // Center the text
              ),
              const SizedBox(height: 20),
              Text("Your Products", style: Theme.of(context).textTheme.headlineMedium),
              _buildAllProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVendorDetails() {
    return StreamBuilder(
      stream: _firestore
          .collection('vendors')
          .where('VendorID', isEqualTo: _user?.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(); // No vendor data available
        }

        var vendorData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
        var vendorImageURL = vendorData['profileImage'] ?? '';
        var vendorName = vendorData['businessName'] ?? '';

        return Column(
          children: [
            Image.network(
              vendorImageURL,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200, // Set the desired height
            ),
            const SizedBox(height: 10),
            Text(
              vendorName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAllProducts() {
    return StreamBuilder(
      stream: _firestore
          .collection('vendors')
          .doc(_user?.uid)
          .collection('products')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No products available");
        }

        return Column(
          children: [
            for (var doc in snapshot.data!.docs)
              _buildProductCard(
                context,
                doc.id,
                doc['imageURL'],
                doc['productTitle'],
                doc['priceOfOneItem'].toString(),
                _user,
              ),
          ],
        );
      },
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
            const Text('Price: \$ ₹price'),
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
              _firestore
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
