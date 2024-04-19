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
  bool isAddressSelected = false;

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
      body: FutureBuilder<DocumentSnapshot>(
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
                      const SizedBox(height: 16.0),
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
                        'Price: ₹ ${calculateTotalPrice(product)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Description: ${product['productDescription'] ?? ''}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Select Address:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 8.0),
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
              onPressed: isAddressSelected ? () => addToCart(context) : null,
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
    return StreamBuilder<QuerySnapshot>(
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

        return SizedBox(
          height: 210.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              var address = addresses[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedAddressId = address.id;
                    isAddressSelected = true;
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
                              isAddressSelected = true;
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

  String calculateTotalPrice(DocumentSnapshot product) {
    double priceOfOneItem = double.parse(product['priceOfOneItem'].toString());
    int minimumQuantity = int.parse(product['minimumQuantity'].toString());
    double totalPrice = priceOfOneItem * minimumQuantity;
    return totalPrice.toStringAsFixed(2);
  }

  Future<DocumentSnapshot> fetchProductDetails() async {
    try {
      return await FirebaseFirestore.instance.collection('products').doc(widget.productID).get();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Fetching Data')),
      );
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
      ScaffoldMessenger.of(context.mounted as BuildContext).showSnackBar(
        const SnackBar(content: Text('Error Fetching Data')),
      );
    }
  }

  void addToCart(BuildContext context) async {
    try {
      if (!isAddressSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select a delivery address')),
        );
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String buyerId = user.uid;

        // Fetch the vendor ID of the current product
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(widget.productID).get();
        String currentProductVendorId = productSnapshot['vendorID'];

        CollectionReference buyerCollection = FirebaseFirestore.instance.collection('buyers');
        QuerySnapshot buyerQuery = await buyerCollection.where('buyerId', isEqualTo: buyerId).get();

        // Check if the cart sub-collection is available
        if (buyerQuery.docs.isNotEmpty) {
          CollectionReference cartCollection = buyerCollection.doc(buyerId).collection('cart');

          // Check if there are any items in the cart
          QuerySnapshot cartQuery = await cartCollection.get();
          if (cartQuery.docs.isNotEmpty) {
            // Fetch the vendor ID of the first item in the cart
            DocumentSnapshot cartItemSnapshot = cartQuery.docs.first;
            String cartItemVendorId = (await FirebaseFirestore.instance.collection('products').doc(cartItemSnapshot['productID']).get())['vendorID'];

            // Check if the vendor ID of the current product matches the vendor ID of the product in the cart
            if (currentProductVendorId == cartItemVendorId) {
              // Add the product to the cart
              await cartCollection.add({
                'productID': widget.productID,
                'orderQuantity': orderQuantity,
                'addressID': selectedAddressId,
                'timestamp': FieldValue.serverTimestamp(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added to cart')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vendor mismatch. Cannot add product to cart.')),
              );
            }
          } else {
            // If the cart is empty, directly add the product to the cart
            await cartCollection.add({
              'productID': widget.productID,
              'orderQuantity': orderQuantity,
              'addressID': selectedAddressId,
              'timestamp': FieldValue.serverTimestamp(),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart')),
            );
          }
        } else {
          // If the cart sub-collection is not available, add the product directly to the cart
          CollectionReference cartCollection = buyerCollection.doc(buyerId).collection('cart');
          await cartCollection.add({
            'productID': widget.productID,
            'orderQuantity': orderQuantity,
            'addressID': selectedAddressId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added to cart')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Fetching Data')),
      );
    }
  }

}
