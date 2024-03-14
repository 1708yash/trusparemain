import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? currentUserId;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Retrieve current user ID from Firebase Authentication
    final User? user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid;
  }

  Future<void> placeOrder() async {
    try {
      String orderID = const Uuid().v1();

      final QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('buyers')
          .doc(currentUserId)
          .collection('cart')
          .get();

      // Grouping products by vendor ID
      Map<String, List<Map<String, dynamic>>> productsByVendor = {};

      for (var cartItem in cartSnapshot.docs) {
        String productID = cartItem['productID'];
        String vendorID = '';
        DocumentSnapshot productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(productID)
            .get();
        if (productDoc.exists) {
          vendorID = productDoc['vendorID'];
          if (!productsByVendor.containsKey(vendorID)) {
            productsByVendor[vendorID] = [];
          }
          productsByVendor[vendorID]!.add({
            'productID': productID,
            'orderQuantity': int.parse(cartItem['orderQuantity'].toString()), // Parse orderQuantity as int
            'addressID': cartItem['addressID']
          });
        }
      }

      // Process orders for each vendor
      for (var vendorID in productsByVendor.keys) {
        List<Map<String, dynamic>> products = productsByVendor[vendorID]!;
        double vendorTotalAmount = 0.0;

        List<String> productIDs = [];
        List<int> orderQuantities = [];
        List<String> addressIDs = [];
        for (var product in products) {
          productIDs.add(product['productID']);
          orderQuantities.add(product['orderQuantity']);
          addressIDs.add(product['addressID']);

          // Parse priceOfOneItem directly into a double
          double priceOfOneItem = double.parse((await FirebaseFirestore.instance
              .collection('products')
              .doc(product['productID'])
              .get())['priceOfOneItem']);

          vendorTotalAmount += priceOfOneItem * product['orderQuantity'];
        }

        // Add the order to the sub-collection of the vendor's collection
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorID)
            .collection('orders')
            .doc(orderID)
            .set({
          'orderID': orderID,
          'totalAmount': vendorTotalAmount,
          'products': productIDs,
          'orderQuantities': orderQuantities,
          'addressIDs': addressIDs,
          'buyerID': currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Add the order to the sub-collection of the buyer's collection
        await FirebaseFirestore.instance
            .collection('buyers')
            .doc(currentUserId)
            .collection('orders')
            .doc(orderID)
            .set({
          'orderID': orderID,
          'totalAmount': vendorTotalAmount,
          'products': productIDs,
          'orderQuantities': orderQuantities,
          'addressIDs': addressIDs,
          'vendorID': vendorID,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Clear the cart
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(currentUserId)
          .collection('cart')
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Update UI or navigate to a success page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully')),
      );
    } catch (e) {
      print('Error placing order: $e');
      // Handle error placing order
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('buyers')
              .doc(currentUserId)
              .collection('cart')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Your Cart is Empty"),
                    const SizedBox(height: 24),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width - 120,
                      child: const Center(
                        child: Text(
                          'Continue Shopping',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Reset total amount on each rebuild
            totalAmount = 0.0;

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var cartItem = snapshot.data?.docs[index];
                String productID = cartItem?['productID'];
                int orderQuantity = cartItem?['orderQuantity'];

                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(productID)
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
                    double priceOfOneItem =
                    double.parse(productData!['priceOfOneItem'].toString());

                    // Calculate total amount for each item
                    double itemTotal = priceOfOneItem * orderQuantity;
                    totalAmount += itemTotal;

                    return Card(
                      child: ListTile(
                        leading: Image.network(imageURL),
                        title: Text(title),
                        subtitle: Text('Quantity: $orderQuantity'),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: ListTile(
                                title: const Text('Delete'),
                                onTap: () {
                                  // Implement deletion logic here
                                  FirebaseFirestore.instance
                                      .collection('buyers')
                                      .doc(currentUserId)
                                      .collection('cart')
                                      .doc(cartItem?.id)
                                      .delete();

                                  // Update total amount on deletion
                                  setState(() {
                                    totalAmount -= itemTotal;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Place order when the button is pressed
                placeOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
              ),
              child: Text(
                'Confirm Order - ₹ ${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
