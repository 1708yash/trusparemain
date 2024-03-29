import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
        padding: const EdgeInsets.all(8.0),
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
              return const Center(
                child: Text("You haven't placed any orders yet."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data?.docs[index];
                List<String> productIDs = List<String>.from(order?['products']);
                List<int> orderQuantities = List<int>.from(
                    order?['orderQuantities']);

                DateTime orderDate = order?['timestamp'].toDate();
                bool canReturn = DateTime
                    .now()
                    .difference(orderDate)
                    .inDays <= 2;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Placed on: ${DateFormat('MMM dd, yyyy hh:mm a')
                              .format(orderDate)}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
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
                          'Total Amount: ₹ ${order?['totalAmount']
                              .toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (canReturn)
                          ElevatedButton(
                            onPressed: () {
                              initiateReturn(order);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                            ),
                            child: const Text('Return'),
                          ),
                      ],
                    ),
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
      // Get complete details of the products from the order
      List<String> productIDs = List<String>.from(order?['products']);
      List<int> orderQuantities = List<int>.from(order?['orderQuantities']);
      List<Map<String, dynamic>> products = [];

      for (int i = 0; i < productIDs.length; i++) {
        var productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productIDs[i])
            .get();

        if (productSnapshot.exists) {
          var productData = productSnapshot.data();
          products.add({
            'productID': productIDs[i],
            'productTitle': productData?['productTitle'],
            'price': productData?['price'],
            'quantity': orderQuantities[i],
            // Add other necessary fields
          });
        }
      }

      // Add the order details along with product details to the 'returns' collection
      await FirebaseFirestore.instance.collection('returns').add({
        'orderID': order?.id,
        'buyerID': currentUserId,
        'timestamp': DateTime.now(),
        'products': products,
        'totalAmount': order?['totalAmount'],
        // Include other necessary fields from the order
      });

      // Add the order to the 'returns' sub collection within the 'buyers' collection
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(currentUserId)
          .collection('returns')
          .add({
        'orderID': order?.id,
        'timestamp': DateTime.now(),
        'products': products,
        'totalAmount': order?['totalAmount'],
        // Include other necessary fields from the order
      });

      // Remove the order from the 'orders' sub collection
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

