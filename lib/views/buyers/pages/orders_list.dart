import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    // Retrieve current user ID from Firebase Authentication
    final User? user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      // User not logged in, you may choose to redirect to the login screen
      return Scaffold(
        appBar: AppBar(
          title: const Text("Your Orders"),
        ),
        body: const Center(
          child: Text("Please log in to view your orders."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('buyers')
              .doc(currentUserId)
              .collection('orders')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: const Text("You haven't placed any orders yet."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data?.docs[index];
                List<String> productIDs = List<String>.from(order?['products']);
                List<int> orderQuantities = List<int>.from(order?['orderQuantities']);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < productIDs.length; i++)
                        ListTile(
                          leading: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('products')
                                .doc(productIDs[i])
                                .get(),
                            builder: (context, productSnapshot) {
                              if (productSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (!productSnapshot.hasData ||
                                  !productSnapshot.data!.exists) {
                                return const SizedBox(); // Handle error or loading state
                              }

                              var productData = productSnapshot.data;
                              String imageURL = productData?['imageURL'];

                              return Image.network(
                                imageURL,
                                width: 50,
                                height: 50,
                              );
                            },
                          ),
                          title: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('products')
                                .doc(productIDs[i])
                                .get(),
                            builder: (context, productSnapshot) {
                              if (productSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (!productSnapshot.hasData ||
                                  !productSnapshot.data!.exists) {
                                return const SizedBox(); // Handle error or loading state
                              }

                              var productData = productSnapshot.data;
                              String title = productData?['productTitle'];

                              return Text(title);
                            },
                          ),
                          subtitle: Text('Quantity: ${orderQuantities[i]}'),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Amount: ₹ ${order?['totalAmount'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Order Placed on: ${order?['timestamp'].toDate().toString()}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );}
}
