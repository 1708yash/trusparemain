import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatefulWidget {
  final String productID;

  const ProductDetailPage({Key? key, required this.productID}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int orderQuantity = 1;
  int minimumQuantityLocal = 1;
  String businessName = '';
  String selectedAddressId = '';

  @override
  void initState() {
    super.initState();
    fetchProductDetails().then((product) {
      if (product.exists) {
        int minimumQuantity = int.parse(product['minimumQuantity'].toString());
        setState(() {
          orderQuantity = minimumQuantity;
          minimumQuantityLocal = minimumQuantity;
        });
        fetchVendorDetails(product['vendorID']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder(
        future: fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var product = snapshot.data;
          if (product == null || !product.exists) {
            return const Center(child: Text('Product not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product['imageURL'],
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Each vendor has some minimum order demands and hence the minimum possible is set at first.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 36.0),
                      Text(
                        product['productTitle'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Provided by: $businessName',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Category: ${product['category'] ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Price: \$${calculateTotalPrice(product)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Description: ${product['productDescription'] ?? ''}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Select Address:',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 210.0,
                        child: buildAddressList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (orderQuantity > minimumQuantityLocal) {
                    orderQuantity--;
                  }
                });
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              'Quantity:  $orderQuantity',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  orderQuantity++;
                });
              },
              icon: const Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () {
                addToCart(context, widget.productID, orderQuantity, selectedAddressId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddressList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('buyers').doc(FirebaseAuth.instance.currentUser!.uid).collection('addresses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var addresses = snapshot.data?.docs;

        if (addresses!.isEmpty) {
          return const Center(child: Text('No addresses found'));
        }

        return Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              var address = addresses[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedAddressId = address.id;
                  });
                },
                child: Card(
                  color: selectedAddressId == address.id ? Colors.blue : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Street: ${address['street']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'City: ${address['city']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'State: ${address['state']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Country: ${address['country']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Pincode: ${address['pincode']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Radio(
                          value: address.id,
                          groupValue: selectedAddressId,
                          onChanged: (value) {
                            setState(() {
                              selectedAddressId = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<DocumentSnapshot> fetchProductDetails() async {
    try {
      return await FirebaseFirestore.instance.collection('products').doc(widget.productID).get();
    } catch (e) {
      print("Error fetching product details: $e");
      rethrow;
    }
  }

  Future<void> fetchVendorDetails(String vendorID) async {
    try {
      DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance.collection('vendors').doc(vendorID).get();
      if (vendorSnapshot.exists) {
        setState(() {
          businessName = vendorSnapshot['businessName'];
        });
      } else {
        setState(() {
          businessName = 'Unknown';
        });
      }
    } catch (e) {
      print("Error fetching vendor details: $e");
    }
  }

  String calculateTotalPrice(DocumentSnapshot product) {
    double priceOfOneItem = double.parse(product['priceOfOneItem'].toString());
    int minimumQuantity = int.parse(product['minimumQuantity'].toString());
    double totalPrice = priceOfOneItem * minimumQuantity;
    return totalPrice.toStringAsFixed(2);
  }

  void addToCart(BuildContext context, String productID, int orderQuantity, String selectedAddressId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String buyerId = user.uid;

        CollectionReference buyerCollection = FirebaseFirestore.instance.collection('buyers');
        QuerySnapshot buyerQuery = await buyerCollection.where('buyerId', isEqualTo: buyerId).get();

        if (buyerQuery.docs.isNotEmpty) {
          CollectionReference cartCollection = buyerCollection.doc(buyerId).collection('cart');

          await cartCollection.add({
            'productID': productID,
            'orderQuantity': orderQuantity,
            'addressID': selectedAddressId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added to cart')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyer not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }
}
