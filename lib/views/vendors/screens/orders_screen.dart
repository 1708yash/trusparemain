import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';

class VendorOrderScreen extends StatefulWidget {
  const VendorOrderScreen({Key? key}) : super(key: key);

  @override
  _VendorOrderScreenState createState() => _VendorOrderScreenState();
}

class _VendorOrderScreenState extends State<VendorOrderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId();
  }

  Future<void> fetchCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Recent Orders'),
                  Tab(text: 'Packed'),
                  Tab(text: 'Shipped'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    buildOrdersView('recent'),
                    buildPackedView('packed'),
                    buildShippedView('shipped'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrdersView(String status) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: currentUserId != null
                ? FirebaseFirestore.instance
                .collection('vendors')
                .doc(currentUserId) // Use currentUserId
                .collection('orders')
                .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No orders available.'),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((orderDoc) {
                  final orderID = orderDoc['orderID'] as String?;
                  final products = orderDoc['products'] as List?;
                  final orderQuantities =
                  orderDoc['orderQuantities'] as List?;
                  final addressIDs = orderDoc['addressIDs'] as List?;

                  if (orderID == null ||
                      products == null ||
                      orderQuantities == null) {
                    return const SizedBox(); // Skip this order if data is not in the correct format
                  }

                  return FutureBuilder<List<DocumentSnapshot>>(
                    future: fetchAddresses(addressIDs),
                    builder: (context, addressSnapshot) {
                      if (addressSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final addresses = addressSnapshot.data ?? [];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.shopping_cart),
                              title: Text('Order ID: $orderID'),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  moveOrderToPacked(orderDoc);
                                },
                                child: const Text('Packed'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: List.generate(
                                products.length,
                                    (index) {
                                  final productID =
                                  products[index] as String?;
                                  final quantity =
                                  orderQuantities[index] as int?;

                                  return FutureBuilder<DocumentSnapshot>(
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
                                        return const SizedBox();
                                        // Skip this product if data is not available
                                      }

                                      final productData =
                                      productSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                      final imageURL =
                                      productData['imageURL'] as String?;
                                      final productTitle =
                                      productData['productTitle']
                                      as String?;

                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: Image.network(
                                              imageURL!,
                                              width: 50,
                                              height: 50,
                                            ),
                                            title: Text(productTitle!),
                                            trailing:
                                            Text('Quantity: $quantity'),
                                            subtitle: addresses.isNotEmpty &&
                                                index < addresses.length &&
                                                addresses[index].exists
                                                ? Text(
                                              'Address: ${addresses[index]['address'] ?? 'Shipment address not provided'}',
                                              style: const TextStyle(
                                                fontStyle:
                                                FontStyle.italic,
                                              ),
                                            )
                                                : const Text(
                                                'Shipment address not provided'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildPackedView(String status) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: currentUserId != null
                ? FirebaseFirestore.instance
                .collection('vendors')
                .doc(currentUserId) // Use currentUserId
                .collection('packed')
                .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No orders available.'),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((orderDoc) {
                  final orderID = orderDoc['orderID'] as String?;
                  final products = orderDoc['products'] as List?;
                  final orderQuantities =
                  orderDoc['orderQuantities'] as List?;

                  if (orderID == null ||
                      products == null ||
                      orderQuantities == null) {
                    return const SizedBox();
                    // Skip this order if data is not in the correct format
                  }

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text('Order ID: $orderID'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              moveOrderToShipped(orderDoc);
                            },
                            child: const Text('Shipped'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(
                            products.length,
                                (index) {
                              final productID =
                              products[index] as String?;
                              final quantity =
                              orderQuantities[index] as int?;

                              return FutureBuilder<DocumentSnapshot>(
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
                                    return const SizedBox();
                                    // Skip this product if data is not available
                                  }

                                  final productData =
                                  productSnapshot.data!.data()
                                  as Map<String, dynamic>;
                                  final imageURL =
                                  productData['imageURL'] as String?;
                                  final productTitle =
                                  productData['productTitle']
                                  as String?;

                                  return ListTile(
                                    leading: Image.network(
                                      imageURL!,
                                      width: 50,
                                      height: 50,
                                    ),
                                    title: Text(productTitle!),
                                    subtitle: Text('Quantity: $quantity'),
                                  );
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildShippedView(String status) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: currentUserId != null
                ? FirebaseFirestore.instance
                .collection('vendors')
                .doc(currentUserId) // Use currentUserId
                .collection('shipped')
                .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No orders available.'),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((orderDoc) {
                  final orderID = orderDoc['orderID'] as String?;
                  final products = orderDoc['products'] as List?;
                  final orderQuantities =
                  orderDoc['orderQuantities'] as List?;

                  if (orderID == null ||
                      products == null ||
                      orderQuantities == null) {
                    return const SizedBox();
                    // Skip this order if data is not in the correct format
                  }

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text('Order ID: $orderID'),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(
                            products.length,
                                (index) {
                              final productID =
                              products[index] as String?;
                              final quantity =
                              orderQuantities[index] as int?;

                              return FutureBuilder<DocumentSnapshot>(
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
                                    return const SizedBox();
                                    // Skip this product if data is not available
                                  }

                                  final productData =
                                  productSnapshot.data!.data()
                                  as Map<String, dynamic>;
                                  final imageURL =
                                  productData['imageURL'] as String?;
                                  final productTitle =
                                  productData['productTitle']
                                  as String?;

                                  return ListTile(
                                    leading: Image.network(
                                      imageURL!,
                                      width: 50,
                                      height: 50,
                                    ),
                                    title: Text(productTitle!),
                                    subtitle: Text('Quantity: $quantity'),
                                  );
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> fetchAddresses(List? addressIDs) async {
    if (addressIDs != null && addressIDs.isNotEmpty) {
      final List<Future<DocumentSnapshot>> futures = [];
      for (final addressID in addressIDs) {
        futures.add(FirebaseFirestore.instance
            .collection('addresses')
            .doc(addressID)
            .get());
      }
      return Future.wait(futures);
    }
    return [];
  }

  void moveOrderToPacked(DocumentSnapshot orderDoc) {
    if (currentUserId != null) {
      FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentUserId!)
          .collection('packed')
          .doc(orderDoc.id)
          .set(orderDoc.data() as Map<String, dynamic>);
      // Delete the order from recent orders
      orderDoc.reference.delete();
    }
  }

  void moveOrderToShipped(DocumentSnapshot orderDoc) {
    if (currentUserId != null) {
      // Push the order data to the 'shipped' sub-collection
      FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentUserId!)
          .collection('shipped')
          .doc(orderDoc.id)
          .set(orderDoc.data() as Map<String, dynamic>);

      // Push the order data to the 'shippedProducts' collection
      FirebaseFirestore.instance
          .collection('shippedProducts')
          .doc(orderDoc.id)
          .set(orderDoc.data() as Map<String, dynamic>);

      // Delete the order from the current sub-collection
      orderDoc.reference.delete();
    }
  }
}

