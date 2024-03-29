import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReturnedOrders extends StatefulWidget {
  const ReturnedOrders({Key? key}) : super(key: key);

  @override
  _ReturnedOrdersState createState() => _ReturnedOrdersState();
}

class _ReturnedOrdersState extends State<ReturnedOrders> {
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
        title: const Text("Your Returned Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('buyers')
              .doc(currentUserId)
              .collection('returns')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("You haven't returned any orders yet."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data?.docs[index];
                return buildReturnedOrderCard(order);
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildReturnedOrderCard(DocumentSnapshot? order) {
    if (order == null) {
      return const SizedBox();
    }

    List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(order['products']);
    DateTime orderDate = order['timestamp'].toDate();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < products.length; i++)
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(products[i]['productID'])
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
                  String title = productData?['productTitle'];

                  return ListTile(
                    leading: Image.network(
                      imageURL,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(title),
                    subtitle: Text('Quantity: ${products[i]['quantity']}'),
                  );
                },
              ),
            const SizedBox(height: 8),
            Text(
              'Total Amount: ₹ ${order['totalAmount'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Order Returned on: ${DateFormat('MMM dd, yyyy hh:mm a').format(orderDate)}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
