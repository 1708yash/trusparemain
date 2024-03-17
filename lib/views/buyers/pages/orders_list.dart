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
              return const Center(
                child: CircularProgressIndicator(),
              );
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

                DateTime orderDate = order?['timestamp'].toDate();
                bool canReturn = DateTime.now().difference(orderDate).inDays <= 2;

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (canReturn)
                              ElevatedButton(
                                onPressed: () {
                                  initiateReturn(order);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan, // Set the button color
                                ),
                                child: const Text('Return'),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              'Order Placed on: ${orderDate.toString()}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void initiateReturn(DocumentSnapshot? order) async {
    try {
      // Add the order to the 'returns' collection
      await FirebaseFirestore.instance.collection('returns').add({
        'orderID': order?.id,
        'buyerID': currentUserId,
        'timestamp': DateTime.now(),
        // Include other necessary fields from the order
      });

      // Add the order to the 'returns' subcollection within the 'buyers' collection
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(currentUserId)
          .collection('returns')
          .add({
        'orderID': order?.id,
        'timestamp': DateTime.now(),
        // Include other necessary fields from the order
      });

      // Remove the order from the 'orders' subcollection
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(currentUserId)
          .collection('orders')
          .doc(order?.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Return initiated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error initiating return: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to initiate return. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
