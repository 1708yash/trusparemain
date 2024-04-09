import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trusparemain/utils/constants/sizes.dart';
import 'package:collection/collection.dart';

import '../main_screen_handler.dart';

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
    return PopScope(
        canPop:false,
        onPopInvoked: (didPop) async {
          // Handle going back
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (
                context) => const MainVendorScreen()), // Replace Home() with your home screen widget
          );
        },
        child:Scaffold(
          appBar: AppBar(
            title: const Text('Vendor Orders'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Recent',),
                      Tab(text: 'Packed'),
                      Tab(text: 'Shipped'),
                      Tab(text: 'Returns'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildOrdersView('recent'),
                        buildPackedView('packed'),
                        buildShippedView('shipped'),
                        buildReturnsView('returns'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
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
                .doc(currentUserId!)
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
                    return const SizedBox();
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
                                      }

                                      final productData =
                                      productSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                      final imageURL =
                                      productData['imageURL'] as String?;
                                      final productTitle =
                                      productData['productTitle']
                                      as String?;

                                      final addressIndex =
                                      addressIDs != null &&
                                          index < addressIDs.length
                                          ? addressIDs[index]
                                          : null;
                                      final address = addresses
                                          .firstWhereOrNull((snapshot) =>
                                      snapshot.id == addressIndex);

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
                                            subtitle: address != null
                                                ? Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  'Address: ${(address.data() as Map<String, dynamic>)['address'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                      FontStyle
                                                          .italic),
                                                ),
                                                Text(
                                                    'City: ${(address.data() as Map<String, dynamic>)['city'] ?? 'N/A'}'),
                                                Text(
                                                    'State: ${(address.data() as Map<String, dynamic>)['state'] ?? 'N/A'}'),
                                                Text(
                                                    'Country: ${(address.data() as Map<String, dynamic>)['country'] ?? 'N/A'}'),
                                                Text(
                                                    'Pincode: ${(address.data() as Map<String, dynamic>)['pincode'] ?? 'N/A'}'),
                                              ],
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
                .doc(currentUserId!)
                .collection('packed')
                .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No packed orders available.'),
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
                    return const SizedBox();
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
                              // Add more details for packed orders if needed
                              trailing: ElevatedButton(
                                onPressed: () {
                                  moveOrderToShipped(orderDoc);
                                },
                                child: const Text('Ship'),
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
                                      }

                                      final productData =
                                      productSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                      final imageURL =
                                      productData['imageURL'] as String?;
                                      final productTitle =
                                      productData['productTitle']
                                      as String?;

                                      final addressIndex =
                                      addressIDs != null &&
                                          index < addressIDs.length
                                          ? addressIDs[index]
                                          : null;
                                      final address = addresses
                                          .firstWhereOrNull((snapshot) =>
                                      snapshot.id == addressIndex);

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
                                            subtitle: address != null
                                                ? Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Address: ${(address.data() as Map<String, dynamic>)['address'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                      FontStyle
                                                          .italic),
                                                ),
                                                Text(
                                                    'City: ${(address.data() as Map<String, dynamic>)['city'] ?? 'N/A'}'),
                                                Text(
                                                    'State: ${(address.data() as Map<String, dynamic>)['state'] ?? 'N/A'}'),
                                                Text(
                                                    'Country: ${(address.data() as Map<String, dynamic>)['country'] ?? 'N/A'}'),
                                                Text(
                                                    'Pincode: ${(address.data() as Map<String, dynamic>)['pincode'] ?? 'N/A'}'),
                                              ],
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
  Widget buildShippedView(String status) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: currentUserId != null
                ? FirebaseFirestore.instance
                .collection('vendors')
                .doc(currentUserId!)
                .collection('shipped')
                .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No shipped orders available.'),
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
                    return const SizedBox();
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
                              // Add more details for shipped orders if needed
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
                                      }

                                      final productData =
                                      productSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                      final imageURL =
                                      productData['imageURL'] as String?;
                                      final productTitle =
                                      productData['productTitle']
                                      as String?;

                                      final addressIndex =
                                      addressIDs != null &&
                                          index < addressIDs.length
                                          ? addressIDs[index]
                                          : null;
                                      final address = addresses
                                          .firstWhereOrNull((snapshot) =>
                                      snapshot.id == addressIndex);

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
                                            subtitle: address != null
                                                ? Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Address: ${(address.data() as Map<String, dynamic>)['address'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                      fontStyle:
                                                      FontStyle
                                                          .italic),
                                                ),
                                                Text(
                                                    'City: ${(address.data() as Map<String, dynamic>)['city'] ?? 'N/A'}'),
                                                Text(
                                                    'State: ${(address.data() as Map<String, dynamic>)['state'] ?? 'N/A'}'),
                                                Text(
                                                    'Country: ${(address.data() as Map<String, dynamic>)['country'] ?? 'N/A'}'),
                                                Text(
                                                    'Pincode: ${(address.data() as Map<String, dynamic>)['pincode'] ?? 'N/A'}'),
                                              ],
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
  Widget buildReturnsView(String status) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: currentUserId != null
                ? FirebaseFirestore.instance
                .collection('vendors')
                .doc(currentUserId!)
                .collection('returns')
                .snapshots()
                : const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No returned orders available.'),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((returnDoc) {
                  final orderID = returnDoc['orderID'] as String?;
                  final timestamp = returnDoc['timestamp'] as Timestamp?;
                  final totalAmount = returnDoc['totalAmount'] as double?;
                  final List<dynamic>? products = returnDoc['products'];
                  final String? reason = returnDoc['reason'];

                  if (orderID == null ||
                      timestamp == null ||
                      totalAmount == null ||
                      products == null ||
                      reason == null) {
                    return const SizedBox();
                  }

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Order ID: $orderID'),
                          subtitle: Text('Timestamp: ${timestamp.toDate()}'),
                        ),
                        ListTile(
                          title: Text('Total Amount: $totalAmount'),
                        ),
                        ListTile(
                          title: Text('Reason: $reason'),
                        ),
                        const Divider(),
                        ...products.map((product) {
                          final productID = product['productID'];
                          final productTitle = product['productTitle'];
                          final quantity = product['quantity'];

                          return ListTile(
                            title: Text('Product ID: $productID'),
                            subtitle: Text(
                                'Product Title: $productTitle\nQuantity: $quantity'),
                          );
                        }).toList(),
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
      FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentUserId!)
          .collection('shipped')
          .doc(orderDoc.id)
          .set(orderDoc.data() as Map<String, dynamic>);

      FirebaseFirestore.instance
          .collection('shippedProducts')
          .doc(orderDoc.id)
          .set(orderDoc.data() as Map<String, dynamic>);

      // Delete the order from packed orders
      FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentUserId!)
          .collection('packed')
          .doc(orderDoc.id)
          .delete();
    }
  }
}
